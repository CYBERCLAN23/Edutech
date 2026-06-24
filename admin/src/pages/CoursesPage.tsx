import { useEffect, useState } from 'react';
import { BookOpen, ChevronDown, ChevronRight, Users } from 'lucide-react';
import { api } from '../lib/api';
import type { AdminCourse } from '../lib/types';

export default function CoursesPage() {
  const [courses, setCourses] = useState<AdminCourse[]>([]);
  const [grouped, setGrouped] = useState<Record<string, AdminCourse[]>>({});
  const [expanded, setExpanded] = useState<Record<string, boolean>>({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  const load = async () => {
    setLoading(true); setError('');
    try {
      const data = await api.getCourses();
      setCourses(data.courses);
      setGrouped(data.grouped);
      const allExpanded: Record<string, boolean> = {};
      Object.keys(data.grouped).forEach(k => { allExpanded[k] = true; });
      setExpanded(allExpanded);
    } catch (err: any) { setError(err.message); }
    finally { setLoading(false); }
  };

  useEffect(() => { load(); }, []);

  const toggle = (className: string) => setExpanded(prev => ({ ...prev, [className]: !prev[className] }));

  if (loading) return <div className="flex justify-center py-20"><div className="animate-spin w-8 h-8 border-4 border-[#4F46E5] border-t-transparent rounded-full" /></div>;
  if (error) return <div className="text-center py-20"><p className="text-red-500 mb-4">{error}</p><button onClick={load} className="px-6 py-2 bg-[#4F46E5] text-white rounded-xl">Réessayer</button></div>;

  const classNames = Object.keys(grouped);
  const totalClasses = classNames.length;

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-bold text-[#0D1B2A]">Cours</h1>
          <p className="text-gray-500 mt-1">{courses.length} cours · {totalClasses} classes</p>
        </div>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
        <div className="bg-white rounded-xl p-4 border border-gray-100">
          <p className="text-2xl font-bold text-[#0D1B2A]">{courses.length}</p>
          <p className="text-sm text-gray-500">Total cours</p>
        </div>
        <div className="bg-white rounded-xl p-4 border border-gray-100">
          <p className="text-2xl font-bold text-[#0D1B2A]">{totalClasses}</p>
          <p className="text-sm text-gray-500">Classes</p>
        </div>
      </div>

      <div className="space-y-4">
        {classNames.map(className => (
          <div key={className} className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
            <button
              onClick={() => toggle(className)}
              className="w-full flex items-center justify-between p-5 hover:bg-gray-50 transition-colors"
            >
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-[#4F46E5]/10 flex items-center justify-center">
                  <Users size={20} className="text-[#4F46E5]" />
                </div>
                <div className="text-left">
                  <h3 className="font-semibold text-[#0D1B2A]">{className}</h3>
                  <p className="text-sm text-gray-400">{grouped[className].length} cours</p>
                </div>
              </div>
              {expanded[className] ? <ChevronDown size={20} className="text-gray-400" /> : <ChevronRight size={20} className="text-gray-400" />}
            </button>

            {expanded[className] && (
              <div className="px-5 pb-4 space-y-2">
                {grouped[className].map(course => {
                  const progress = course.total_lessons > 0 ? Math.round((course.completed_lessons / course.total_lessons) * 100) : 0;
                  return (
                    <div key={course.id} className="flex items-center gap-4 p-3 rounded-xl hover:bg-gray-50 transition-colors">
                      <div className="w-10 h-10 rounded-xl bg-[#F59E0B]/10 flex items-center justify-center shrink-0">
                        <BookOpen size={18} className="text-[#F59E0B]" />
                      </div>
                      <div className="flex-1 min-w-0">
                        <p className="text-sm font-medium text-[#0D1B2A]">{course.subject_name}</p>
                        <p className="text-xs text-gray-400">Prof: {course.users?.name ?? 'Non assigné'}</p>
                      </div>
                      <div className="w-32">
                        <div className="flex items-center justify-between text-xs text-gray-500 mb-1">
                          <span>Progression</span>
                          <span>{course.completed_lessons}/{course.total_lessons}</span>
                        </div>
                        <div className="h-1.5 bg-gray-100 rounded-full overflow-hidden">
                          <div className="h-full bg-[#4F46E5] rounded-full transition-all" style={{ width: `${progress}%` }} />
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        ))}
        {classNames.length === 0 && <p className="text-center py-10 text-gray-400">Aucun cours créé</p>}
      </div>
    </div>
  );
}
