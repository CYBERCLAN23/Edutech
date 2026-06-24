import path from 'path';
import { bundle } from '@remotion/bundler';
import { renderMedia, selectComposition } from '@remotion/renderer';

async function render(inputScriptPath: string, outputPath?: string) {
  const script = require(path.resolve(inputScriptPath));
  const out = outputPath || path.join(process.cwd(), 'out', `${script.title?.replace(/\s+/g, '_') || 'video'}.mp4`);

  const bundleLocation = await bundle({
    entryPoint: path.resolve(__dirname, 'Root.tsx'),
    webpackOverride: (config) => config,
  });

  const composition = await selectComposition({
    serveUrl: bundleLocation,
    id: 'VideoScript',
    inputProps: { script },
  });

  console.log(`Rendering: ${script.title} (${Math.round(composition.durationInFrames / composition.fps)}s)`);

  await renderMedia({
    composition,
    serveUrl: bundleLocation,
    codec: 'h264',
    outputLocation: out,
    inputProps: { script },
  });

  console.log(`✓ Rendered to: ${out}`);
}

const scriptPath = process.argv[2];
if (!scriptPath) {
  console.error('Usage: npx tsx src/render.ts <path-to-script.json> [output-path]');
  process.exit(1);
}

render(scriptPath, process.argv[3]).catch((err) => {
  console.error('Render failed:', err);
  process.exit(1);
});
