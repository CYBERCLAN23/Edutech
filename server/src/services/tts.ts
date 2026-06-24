import { exec } from 'child_process';
import { promisify } from 'util';
import path from 'path';
import fs from 'fs';

const execAsync = promisify(exec);
const TTS_CACHE_DIR = path.join(__dirname, '../../data/tts');

if (!fs.existsSync(TTS_CACHE_DIR)) {
  fs.mkdirSync(TTS_CACHE_DIR, { recursive: true });
}

interface TTSOptions {
  text: string;
  voice?: string;
  lang?: string;
  outputPath?: string;
}

const defaultVoice: Record<string, string> = {
  fr: 'fr-FR-DeniseNeural',
  en: 'en-US-JennyNeural',
};

export async function generateNarration(options: TTSOptions): Promise<Buffer> {
  const { text, voice, lang = 'fr', outputPath } = options;
  const selectedVoice = voice || defaultVoice[lang] || defaultVoice.fr;
  const outPath = outputPath || path.join(TTS_CACHE_DIR, `narration_${Date.now()}.mp3`);

  try {
    await execAsync(`edge-tts --voice "${selectedVoice}" --text "${text.replace(/"/g, '\\"')}" --write-media "${outPath}"`);
    return fs.readFileSync(outPath);
  } catch (err) {
    console.error('Edge-TTS failed, falling back to text-only:', (err as Error).message);
    return Buffer.from(text);
  }
}

export async function generateScenesAudio(
  scenes: { sceneNumber: number; narration: string }[],
  lang: string,
): Promise<{ sceneNumber: number; audioBuffer: Buffer; duration: number }[]> {
  const results: { sceneNumber: number; audioBuffer: Buffer; duration: number }[] = [];

  for (const scene of scenes) {
    try {
      const outPath = path.join(TTS_CACHE_DIR, `scene_${scene.sceneNumber}_${Date.now()}.mp3`);
      const voice = defaultVoice[lang] || defaultVoice.fr;
      await execAsync(
        `edge-tts --voice "${voice}" --text "${scene.narration.replace(/"/g, '\\"')}" --write-media "${outPath}"`,
      );
      const buf = fs.readFileSync(outPath);
      const probe = await execAsync(
        `ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${outPath}"`,
      );
      const duration = parseFloat(probe.stdout.trim()) || scene.narration.length / 15;
      results.push({ sceneNumber: scene.sceneNumber, audioBuffer: buf, duration });
      fs.unlinkSync(outPath);
    } catch {
      const estimatedDuration = scene.narration.length / 15;
      results.push({ sceneNumber: scene.sceneNumber, audioBuffer: Buffer.from(scene.narration), duration: estimatedDuration });
    }
  }

  return results;
}
