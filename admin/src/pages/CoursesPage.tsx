import { useEffect, useState } from 'react';
import { BookOpen, ChevronDown, ChevronRight, Users } from 'lucide-react';
import { api } from '../lib/api';
import { useLang } from '../context/LangContext';
import type { AdminCourse } from '../lib/types';

export default function CoursesPage() {
  const { t } = useLang();
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

  if (loading) return <div className="flex justify-center py-20"><div className="animate-spin w-8 h-8 border-4 border-primary border-t-transparent rounded-full" /></div>;
  if (error) return <div className="text-center py-20"><p className="text-error mb-4">{error}</p><button onClick={load} className="px-6 py-2 bg-primary text-white rounded-xl soft-gradient">{t.courses.retry}</button></div>;

  const classNames = Object.keys(grouped);
  const totalClasses = classNames.length;
  const cm = t.courses;

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-bold text-primary dark:text-white">{cm.title}</h1>
          <p className="text-on-surface-variant dark:text-white/60 mt-1">{courses.length} {cm.subtitle.replace('·', '·').replace('classes', `${totalClasses} ${cm.classes.toLowerCase()}`)}</p>
        </div>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
        <div className="glass-card dark:bg-white/5 rounded-xl p-4">
          <p className="text-2xl font-bold text-primary dark:text-white">{courses.length}</p>
          <p className="text-sm text-on-surface-variant dark:text-white/60">{cm.totalCourses}</p>
        </div>
        <div className="glass-card dark:bg-white/5 rounded-xl p-4">
          <p className="text-2xl font-bold text-primary dark:text-white">{totalClasses}</p>
          <p className="text-sm text-on-surface-variant dark:text-white/60">{cm.classes}</p>
        </div>
      </div>

      <div className="space-y-4">
        {classNames.map(className => (
          <div key={className} className="glass-card dark:bg-white/5 rounded-2xl overflow-hidden">
            <button
              onClick={() => toggle(className)}
              className="w-full flex items-center justify-between p-5 hover:bg-surface-container dark:hover:bg-white/5 transition-colors"
            >
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center">
                  <Users size={20} className="text-primary" />
                </div>
                <div className="text-left">
                  <h3 className="font-semibold text-on-surface dark:text-white">{className}</h3>
                  <p className="text-sm text-on-surface-variant dark:text-white/60">{grouped[className].length} {cm.title.toLowerCase()}</p>
                </div>
              </div>
              {expanded[className] ? <ChevronDown size={20} className="text-outline dark:text-white/40" /> : <ChevronRight size={20} className="text-outline dark:text-white/40" />}
            </button>

            {expanded[className] && (
              <div className="px-5 pb-4 space-y-2">
                {grouped[className].map(course => {
                  const progress = course.total_lessons > 0 ? Math.round((course.completed_lessons / course.total_lessons) * 100) : 0;
                  return (
                    <div key={course.id} className="flex items-center gap-4 p-3 rounded-xl hover:bg-surface-container dark:hover:bg-white/5 transition-colors">
                      <div className="w-10 h-10 rounded-xl bg-amber-50 flex items-center justify-center shrink-0">
                        <BookOpen size={18} className="text-amber-600" />
                      </div>
                      <div className="flex-1 min-w-0">
                        <p className="text-sm font-medium text-on-surface dark:text-white">{course.subject_name}</p>
                        <p className="text-xs text-on-surface-variant dark:text-white/60">{cm.teacher}: {course.users?.name ?? cm.unassigned}</p>
                      </div>
                      <div className="w-32">
                        <div className="flex items-center justify-between text-xs text-on-surface-variant dark:text-white/60 mb-1">
                          <span>{cm.progress}</span>
                          <span>{course.completed_lessons}/{course.total_lessons}</span>
                        </div>
                        <div className="h-1.5 bg-surface-container dark:bg-white/10 rounded-full overflow-hidden">
                          <div className="h-full bg-primary rounded-full transition-all" style={{ width: `${progress}%` }} />
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        ))}
        {classNames.length === 0 && <p className="text-center py-10 text-on-surface-variant dark:text-white/40">{cm.noCourses}</p>}
      </div>
    </div>
  );
}
