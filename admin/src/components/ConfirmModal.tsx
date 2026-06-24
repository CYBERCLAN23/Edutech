import { AlertTriangle, X } from 'lucide-react';

interface Props {
  title: string;
  message: string;
  confirmLabel?: string;
  cancelLabel?: string;
  danger?: boolean;
  loading?: boolean;
  error?: string;
  onConfirm: () => void;
  onCancel: () => void;
}

export default function ConfirmModal({
  title, message, confirmLabel = 'Confirmer', cancelLabel = 'Annuler',
  danger, loading, error, onConfirm, onCancel,
}: Props) {
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
      <div className="glass-card rounded-2xl w-full max-w-sm p-6 mx-4">
        <div className="flex items-start gap-4 mb-4">
          <div className={`p-3 rounded-full shrink-0 ${danger ? 'bg-error-container' : 'bg-primary-container/20'}`}>
            <AlertTriangle size={22} className={danger ? 'text-error' : 'text-primary'} />
          </div>
          <div className="flex-1 min-w-0">
            <h3 className="text-lg font-bold text-on-surface">{title}</h3>
            <p className="text-sm text-on-surface-variant mt-1">{message}</p>
          </div>
          <button onClick={onCancel} className="p-1 hover:bg-surface-container rounded-lg transition-colors">
            <X size={16} className="text-outline" />
          </button>
        </div>

        {error && (
          <div className="mb-4 p-3 bg-error-container border border-error/20 rounded-xl">
            <p className="text-sm text-on-error-container">{error}</p>
          </div>
        )}

        <div className="flex gap-3">
          <button onClick={onCancel} disabled={loading}
            className="flex-1 px-4 py-3 border border-outline-variant rounded-xl text-sm font-medium text-on-surface-variant hover:bg-surface-container disabled:opacity-50 transition-all">
            {cancelLabel}
          </button>
          <button onClick={onConfirm} disabled={loading}
            className={`flex-1 px-4 py-3 rounded-xl text-sm font-medium text-white disabled:opacity-50 transition-all ${
              danger ? 'bg-error hover:bg-error/90' : 'bg-primary hover:brightness-110'
            }`}>
            {loading ? 'Suppression...' : confirmLabel}
          </button>
        </div>
      </div>
    </div>
  );
}
