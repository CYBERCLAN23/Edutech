import { Router, Request, Response } from 'express';
import { generateVideoScript, VideoScript } from '../services/video';
import { generateNarration } from '../services/tts';
import { uploadToStorage } from '../services/storage';

const router = Router();

router.post('/script', async (req: Request, res: Response) => {
  try {
    const { topic, subject, classLevel, duration } = req.body;
    if (!topic || !subject || !classLevel) {
      res.status(400).json({ error: 'topic, subject, classLevel are required' });
      return;
    }

    const script = await generateVideoScript(topic, subject, classLevel, duration || 'medium');
    res.json({ success: true, script });
  } catch (err) {
    console.error('Script generation error:', err);
    res.status(500).json({ error: (err as Error).message });
  }
});

router.post('/narration', async (req: Request, res: Response) => {
  try {
    const { text, lang } = req.body;
    if (!text) {
      res.status(400).json({ error: 'text is required' });
      return;
    }

    const audio = await generateNarration({ text, lang: lang || 'fr' });

    const fileName = `tts/narration_${Date.now()}.mp3`;
    const { url, publicUrl } = await uploadToStorage({
      bucket: 'media',
      fileName,
      fileBuffer: audio,
      contentType: 'audio/mpeg',
    });

    res.json({ success: true, url, publicUrl, size: audio.length });
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

router.post('/full', async (req: Request, res: Response) => {
  try {
    const { topic, subject, classLevel, duration, language } = req.body;
    if (!topic || !subject || !classLevel) {
      res.status(400).json({ error: 'topic, subject, classLevel are required' });
      return;
    }

    const script: VideoScript = await generateVideoScript(topic, subject, classLevel, duration || 'medium');

    const narrationResults = await Promise.allSettled(
      (script.scenes || []).map((scene: { narration: string }) =>
        generateNarration({ text: scene.narration, lang: language || 'fr' }),
      ),
    );

    const scenesWithAudio = (script.scenes || []).map((scene: { sceneNumber: number }, i: number) => ({
      ...scene,
      audioAvailable: narrationResults[i]?.status === 'fulfilled',
    }));

    const full = {
      ...script,
      scenes: scenesWithAudio,
      generatedAt: new Date().toISOString(),
    };

    const fileName = `scripts/script_${Date.now()}.json`;
    await uploadToStorage({
      bucket: 'media',
      fileName,
      fileBuffer: Buffer.from(JSON.stringify(full, null, 2)),
      contentType: 'application/json',
    });

    res.json({
      success: true,
      script: full,
      narrationStatus: narrationResults.map((r: PromiseSettledResult<Buffer>) =>
        r.status === 'fulfilled' ? 'generated' : 'failed',
      ),
    });
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

export default router;
