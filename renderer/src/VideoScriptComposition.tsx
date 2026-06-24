import React from 'react';
import { AbsoluteFill, Sequence, useVideoConfig } from 'remotion';
import { VideoScript } from './types';
import SceneSlide from './Scene';

export const VideoScriptComposition: React.FC<{ script: VideoScript }> = ({ script }) => {
  const { fps } = useVideoConfig();

  let currentFrame = 0;
  const scenes = script.scenes.map((scene, index) => {
    const start = currentFrame;
    const durationFrames = scene.duration * fps;
    currentFrame += durationFrames;
    return { scene, index, start, durationFrames };
  });

  return (
    <AbsoluteFill style={{ background: '#0D1B2A' }}>
      {scenes.map(({ scene, index, start, durationFrames }) => (
        <Sequence key={index} from={start} durationInFrames={durationFrames}>
          <SceneSlide data={scene} index={index} />
        </Sequence>
      ))}
    </AbsoluteFill>
  );
};
