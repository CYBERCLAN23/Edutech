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
      <div className="bg-white rounded-2xl w-full max-w-sm p-6 mx-4 shadow-2xl">
        <div className="flex items-start gap-4 mb-4">
          <div className={`p-3 rounded-full shrink-0 ${danger ? 'bg-red-50' : 'bg-indigo-50'}`}>
            <AlertTriangle size={22} className={danger ? 'text-red-500' : 'text-[#4F46E5]'} />
          </div>
          <div className="flex-1 min-w-0">
            <h3 className="text-lg font-bold text-[#0D1B2A]">{title}</h3>
            <p className="text-sm text-gray-500 mt-1">{message}</p>
          </div>
          <button onClick={onCancel} className="p-1 hover:bg-gray-100 rounded-lg transition-colors">
            <X size={16} className="text-gray-400" />
          </button>
        </div>

        {error && (
          <div className="mb-4 p-3 bg-red-50 border border-red-100 rounded-xl">
            <p className="text-sm text-red-600">{error}</p>
          </div>
        )}

        <div className="flex gap-3">
          <button onClick={onCancel} disabled={loading}
            className="flex-1 px-4 py-3 border border-gray-200 rounded-xl text-sm font-medium text-gray-600 hover:bg-gray-50 disabled:opacity-50 transition-all">
            {cancelLabel}
          </button>
          <button onClick={onConfirm} disabled={loading}
            className={`flex-1 px-4 py-3 rounded-xl text-sm font-medium text-white disabled:opacity-50 transition-all ${
              danger ? 'bg-red-500 hover:bg-red-600' : 'bg-[#4F46E5] hover:bg-[#4338CA]'
            }`}>
            {loading ? 'Suppression...' : confirmLabel}
          </button>
        </div>
      </div>
    </div>
  );
}
