import axios from 'axios';
import { config } from '../config';
import { OpenRouterRequest, OpenRouterResponse } from '../types';

export async function chatCompletion(
  messages: { role: 'system' | 'user' | 'assistant'; content: string }[],
  temperature = 0.7,
  maxTokens = 1024
): Promise<string> {
  const body: OpenRouterRequest = {
    model: config.openrouter.model,
    messages,
    temperature,
    max_tokens: maxTokens,
  };

  const response = await axios.post<OpenRouterResponse>(
    `${config.openrouter.baseUrl}/chat/completions`,
    body,
    {
      headers: {
        Authorization: `Bearer ${config.openrouter.apiKey}`,
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://educam.cm',
        'X-Title': 'EduCam AI',
      },
      timeout: 30000,
    }
  );

  return response.data.choices[0]?.message?.content || '';
}

export async function* streamChatCompletion(
  messages: { role: 'system' | 'user' | 'assistant'; content: string }[],
  temperature = 0.7
): AsyncGenerator<string> {
  const response = await axios.post(
    `${config.openrouter.baseUrl}/chat/completions`,
    {
      model: config.openrouter.model,
      messages,
      temperature,
      stream: true,
    } as OpenRouterRequest,
    {
      headers: {
        Authorization: `Bearer ${config.openrouter.apiKey}`,
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://educam.cm',
        'X-Title': 'EduCam AI',
      },
      responseType: 'stream',
      timeout: 60000,
    }
  );

  const stream = response.data;
  let buffer = '';

  for await (const chunk of stream) {
    buffer += chunk.toString();
    const lines = buffer.split('\n');
    buffer = lines.pop() || '';

    for (const line of lines) {
      const trimmed = line.trim();
      if (!trimmed || !trimmed.startsWith('data: ')) continue;
      const data = trimmed.slice(6);
      if (data === '[DONE]') return;
      try {
        const parsed = JSON.parse(data);
        const content = parsed.choices?.[0]?.delta?.content || '';
        if (content) yield content;
      } catch {
        // skip parse errors
      }
    }
  }
}
