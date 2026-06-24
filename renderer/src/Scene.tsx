import React from 'react';
import { AbsoluteFill, useCurrentFrame, useVideoConfig, interpolate, spring } from 'remotion';
import { Scene, getSubjectColor, visualTypeColors } from './colors';

const scene: React.CSSProperties = {
  width: '100%',
  height: '100%',
  display: 'flex',
  flexDirection: 'column',
  alignItems: 'center',
  justifyContent: 'center',
  padding: 40,
  fontFamily: "'Plus Jakarta Sans', 'Inter', sans-serif",
  position: 'relative',
  overflow: 'hidden',
};

function getIcon(visualType: string) {
  switch (visualType) {
    case 'title': return '🎓';
    case 'content': return '📖';
    case 'example': return '💡';
    case 'formula': return '📐';
    case 'summary': return '✅';
    default: return '📝';
  }
}

function SceneSlide({ data, index }: { data: import('./types').Scene; index: number }) {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const duration = data.duration * fps;
  const subj = getSubjectColor(data.subject);
  const grad = visualTypeColors[data.visualType] || visualTypeColors.content;

  const progress = interpolate(frame, [0, duration * 0.1, duration * 0.9, duration], [0, 1, 1, 0]);
  const slideIn = spring({ frame, fps, config: { damping: 15, stiffness: 80 } });

  const formattedText = data.visualDescription
    .replace(/\\n/g, '\n')
    .split('\n')
    .filter(Boolean);

  return (
    <AbsoluteFill style={{ opacity: progress }}>
      <div style={{ ...scene, background: grad }}>
        <div style={{
          position: 'absolute',
          top: 30,
          left: 30,
          fontSize: 14,
          color: 'rgba(255,255,255,0.5)',
          letterSpacing: 2,
          textTransform: 'uppercase' as const,
          fontWeight: 600,
        }}>
          {data.subject} · Scène {index + 1}
        </div>

        <div style={{
          position: 'absolute',
          top: -100,
          right: -100,
          width: 400,
          height: 400,
          borderRadius: '50%',
          background: `radial-gradient(circle, ${subj.accent}33 0%, transparent 70%)`,
          opacity: 0.6,
        }} />

        <div style={{
          transform: `translateY(${(1 - slideIn) * 60}px)`,
          opacity: slideIn,
          textAlign: 'center' as const,
          zIndex: 1,
          maxWidth: '90%',
        }}>
          <div style={{ fontSize: 48, marginBottom: 20 }}>{getIcon(data.visualType)}</div>

          {formattedText.map((line, i) => {
            const delay = i * 5;
            const lineOpacity = interpolate(
              frame,
              [delay, delay + 15],
              [0, 1],
              { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
            );

            if (line.startsWith('#')) {
              return (
                <div
                  key={i}
                  style={{
                    color: '#FFFFFF',
                    fontSize: 38,
                    fontWeight: 700,
                    lineHeight: 1.4,
                    marginBottom: 12,
                    textShadow: '0 2px 10px rgba(0,0,0,0.3)',
                    opacity: lineOpacity,
                  }}
                >
                  {line.replace(/^#+\s*/, '')}
                </div>
              );
            }

            if (line.startsWith('-') || line.startsWith('*')) {
              return (
                <div
                  key={i}
                  style={{
                    color: 'rgba(255,255,255,0.9)',
                    fontSize: 22,
                    lineHeight: 1.6,
                    marginBottom: 8,
                    paddingLeft: 20,
                    opacity: lineOpacity,
                    textAlign: 'left' as const,
                    maxWidth: 700,
                  }}
                >
                  {line.replace(/^[-*]\s*/, '•  ')}
                </div>
              );
            }

            if (line.startsWith('!')) {
              return (
                <div
                  key={i}
                  style={{
                    background: 'rgba(255,255,255,0.12)',
                    borderRadius: 12,
                    padding: '12px 24px',
                    marginBottom: 8,
                    color: subj.accent,
                    fontSize: 20,
                    fontWeight: 600,
                    opacity: lineOpacity,
                    borderLeft: `4px solid ${subj.accent}`,
                    textAlign: 'left' as const,
                    maxWidth: 700,
                  }}
                >
                  {line.replace(/^!\s*/, '')}
                </div>
              );
            }

            return (
              <div
                key={i}
                style={{
                  color: 'rgba(255,255,255,0.85)',
                  fontSize: line.length > 80 ? 20 : 24,
                  lineHeight: 1.5,
                  marginBottom: 6,
                  opacity: lineOpacity,
                  maxWidth: 700,
                }}
              >
                {line}
              </div>
            );
          })}
        </div>

        <div style={{
          position: 'absolute',
          bottom: 30,
          left: 40,
          right: 40,
          display: 'flex',
          alignItems: 'center',
          gap: 12,
        }}>
          <div style={{
            flex: 1,
            height: 3,
            background: 'rgba(255,255,255,0.2)',
            borderRadius: 2,
            overflow: 'hidden',
          }}>
            <div style={{
              width: `${(frame / duration) * 100}%`,
              height: '100%',
              background: subj.accent,
              borderRadius: 2,
              transition: 'width 0.1s linear',
            }} />
          </div>
          <div style={{ color: 'rgba(255,255,255,0.5)', fontSize: 12, fontVariantNumeric: 'tabular-nums' }}>
            {`${Math.floor(frame / fps)}s / ${data.duration}s`}
          </div>
        </div>
      </div>
    </AbsoluteFill>
  );
}

export default SceneSlide;
