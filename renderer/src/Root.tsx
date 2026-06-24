import React from 'react';
import { Composition } from 'remotion';
import { VideoScriptComposition } from './VideoScriptComposition';
import { VideoScript } from './types';

const sampleScript: VideoScript = {
  title: "Introduction aux Nombres Relatifs",
  subject: "Mathématiques",
  class: "4ème",
  language: "fr",
  totalDuration: 60,
  scenes: [
    {
      sceneNumber: 1,
      duration: 8,
      narration: "Bienvenue dans ce cours sur les nombres relatifs. Aujourd'hui, nous allons découvrir ce que sont les nombres positifs et négatifs.",
      visualDescription: "# Les Nombres Relatifs\n\n## Cours de Mathématiques - 4ème\n\nAvec M. Kamga\n! Prépare-toi à découvrir un nouveau monde de nombres!",
      visualType: "title",
      subject: "Mathématiques",
    },
    {
      sceneNumber: 2,
      duration: 12,
      narration: "Un nombre relatif est un nombre qui peut être positif ou négatif. Par exemple, la température peut être de 5 degrés ou de -3 degrés.",
      visualDescription: "# Qu'est-ce qu'un nombre relatif ?\n\n- Un nombre qui porte un signe (+ ou -)\n- Les nombres positifs : +5, +12, +30\n- Les nombres négatifs : -3, -15, -8\n- Le zéro est le seul nombre sans signe\n\n! +5 et 5 sont la même chose!",
      visualType: "content",
      subject: "Mathématiques",
    },
    {
      sceneNumber: 3,
      duration: 10,
      narration: "Prenons un exemple concret. Si tu as 1000 francs dans ton compte et que tu dépenses 1500 francs, ton solde sera de -500 francs.",
      visualDescription: "# Exemple concret\n\nSolde bancaire : +1000 FCFA\nDépense : -1500 FCFA\nNouveau solde : -500 FCFA\n\nLe signe - indique que tu dois de l'argent à la banque.",
      visualType: "example",
      subject: "Mathématiques",
    },
    {
      sceneNumber: 4,
      duration: 10,
      narration: "Sur une droite graduée, les nombres positifs sont à droite du zéro et les nombres négatifs sont à gauche.",
      visualDescription: "# La droite numérique\n\n... -5  -4  -3  -2  -1  0  +1  +2  +3  +4  +5 ...\n\n← Négatifs | Positifs →\n\n! Plus un nombre est éloigné de zéro, plus sa valeur absolue est grande",
      visualType: "formula",
      subject: "Mathématiques",
    },
    {
      sceneNumber: 5,
      duration: 10,
      narration: "Pour comparer deux nombres relatifs, souviens-toi : un nombre positif est toujours plus grand qu'un nombre négatif.",
      visualDescription: "# Comparer les nombres relatifs\n\n+5 > -3 (un positif est toujours plus grand)\n-2 > -5 (le plus proche de zéro est le plus grand)\n-8 < -1\n\n! Règle : positif > 0 > négatif",
      visualType: "content",
      subject: "Mathématiques",
    },
    {
      sceneNumber: 6,
      duration: 10,
      narration: "Excellent travail ! Tu as appris ce que sont les nombres relatifs, comment les reconnaître et les comparer. Continue à t'entraîner !",
      visualDescription: "# Ce que tu as appris aujourd'hui\n\n✅ Définition des nombres relatifs\n✅ Exemples concrets de la vie quotidienne\n✅ La droite numérique\n✅ Comparaison de nombres\n\nBravo ! Tu es prêt pour la suite ! 🎉",
      visualType: "summary",
      subject: "Mathématiques",
    },
  ],
};

export const Root: React.FC = () => {
  const totalFrames = sampleScript.scenes.reduce((acc, s) => acc + s.duration, 0) * 30;

  return (
    <Composition
      id="VideoScript"
      component={VideoScriptComposition}
      durationInFrames={totalFrames}
      fps={30}
      width={1920}
      height={1080}
      defaultProps={{ script: sampleScript }}
    />
  );
};
