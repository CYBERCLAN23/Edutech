import { useEffect, useState } from 'react';
import { Users, GraduationCap, BookOpen, MessageSquare, Star, RefreshCw } from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import StatCard from '../components/StatCard';
import { api } from '../lib/api';
import { useLang } from '../context/LangContext';
import type { DashboardStats, ClassStats, AdminActivity } from '../lib/types';

export default function DashboardPage() {
  const { t } = useLang();
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [classStats, setClassStats] = useState<ClassStats[]>([]);
  const [activities, setActivities] = useState<AdminActivity[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  const load = async () => {
    setLoading(true);
    setError('');
    try {
      const [d, cs, acts] = await Promise.all([
        api.getDashboard(),
        api.getClassStats(),
        api.getActivities(10),
      ]);
      setStats(d);
      setClassStats(cs);
      setActivities(acts);
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { load(); }, []);

  if (loading) return (
    <div className="flex items-center justify-center h-96"><div className="animate-spin w-8 h-8 border-4 border-primary border-t-transparent rounded-full" /></div>
  );

  if (error) return (
    <div className="text-center py-20">
      <p className="text-error mb-4">{error}</p>
      <button onClick={load} className="px-6 py-2 bg-primary text-white rounded-xl hover:brightness-110 soft-gradient">{t.dashboard.retry}</button>
    </div>
  );

  const chartData = classStats.map(cs => ({
    name: cs.className,
    Moyenne: cs.averageGrade,
    Élèves: cs.studentCount,
  }));

  const dm = t.dashboard;

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-bold text-primary dark:text-white">{dm.title}</h1>
          <p className="text-on-surface-variant dark:text-white/60 mt-1">{dm.subtitle}</p>
        </div>
        <button onClick={load} className="flex items-center gap-2 px-4 py-2 text-sm text-on-surface-variant dark:text-white/60 hover:text-primary border border-outline-variant dark:border-white/20 rounded-xl hover:border-primary transition-all glass-card">
          <RefreshCw size={16} /> {dm.refresh}
        </button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
        <StatCard label={dm.totalUsers} value={stats?.totalUsers ?? 0} icon={<Users size={22} />} color="#00677f" />
        <StatCard label={dm.totalStudents} value={stats?.totalStudents ?? 0} icon={<GraduationCap size={22} />} color="#406900" />
        <StatCard label={dm.totalTeachers} value={stats?.totalTeachers ?? 0} icon={<Users size={22} />} color="#055db6" subtitle={`${stats?.totalAdmins ?? 0} ${dm.admins}`} />
        <StatCard label={dm.totalCourses} value={stats?.totalCourses ?? 0} icon={<BookOpen size={22} />} color="#f59e0b" />
        <StatCard label={dm.avgGrade} value={stats?.averageGrade ?? 0} icon={<Star size={22} />} color="#f59e0b" subtitle="/20" />
        <StatCard label={dm.messages} value={stats?.totalChatMessages ?? 0} icon={<MessageSquare size={22} />} color="#00d2ff" />
        <StatCard label={dm.activities7d} value={stats?.totalActivities ?? 0} icon={<RefreshCw size={22} />} color="#406900" />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
        <div className="glass-card rounded-2xl p-6 dark:bg-white/5">
          <h2 className="text-lg font-semibold text-on-surface dark:text-white mb-4">{dm.classPerf}</h2>
          {chartData.length > 0 ? (
            <ResponsiveContainer width="100%" height={250}>
              <BarChart data={chartData}>
                <CartesianGrid strokeDasharray="3 3" stroke="#e0e3e5" />
                <XAxis dataKey="name" tick={{ fontSize: 12 }} />
                <YAxis domain={[0, 20]} tick={{ fontSize: 12 }} />
                <Tooltip />
                <Bar dataKey="Moyenne" fill="#00677f" radius={[6, 6, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          ) : <p className="text-on-surface-variant dark:text-white/40 text-sm">{dm.noData}</p>}
        </div>

        <div className="glass-card rounded-2xl p-6 dark:bg-white/5">
          <h2 className="text-lg font-semibold text-on-surface dark:text-white mb-4">{dm.classes}</h2>
          <div className="space-y-3">
            {classStats.map(cs => {
              const color = cs.averageGrade >= 12 ? 'text-tertiary' : cs.averageGrade >= 8 ? 'text-amber-600' : 'text-error';
              const bg = cs.averageGrade >= 12 ? 'bg-tertiary/10' : cs.averageGrade >= 8 ? 'bg-amber-50' : 'bg-error-container/30';
              return (
                <div key={cs.className} className="flex items-center justify-between p-4 rounded-xl border border-outline-variant/10 hover:shadow-sm transition-shadow glass-card dark:bg-white/5">
                  <div>
                    <p className="font-medium text-on-surface dark:text-white">{cs.className}</p>
                    <p className="text-sm text-on-surface-variant dark:text-white/60">{cs.studentCount} {dm.students}</p>
                  </div>
                  <div className={`px-3 py-1.5 rounded-lg ${bg}`}>
                    <span className={`font-bold ${color}`}>{cs.averageGrade}/20</span>
                  </div>
                </div>
              );
            })}
            {classStats.length === 0 && <p className="text-on-surface-variant dark:text-white/40 text-sm">{dm.noClass}</p>}
          </div>
        </div>
      </div>

      <div className="glass-card rounded-2xl p-6 dark:bg-white/5">
        <h2 className="text-lg font-semibold text-on-surface dark:text-white mb-4">{dm.recentActivity}</h2>
        {activities.length > 0 ? (
          <div className="space-y-3">
            {activities.map(a => (
              <div key={a.id} className="flex items-center gap-4 p-3 rounded-xl hover:bg-surface-container dark:hover:bg-white/5 transition-colors">
                <div className={`w-10 h-10 rounded-xl flex items-center justify-center text-white text-sm font-bold ${
                  a.type === 'quiz' ? 'bg-amber-500' : a.type === 'exercice' ? 'bg-tertiary' : 'bg-primary'
                }`}>
                  {a.type === 'quiz' ? 'Q' : a.type === 'exercice' ? 'E' : 'C'}
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium text-on-surface dark:text-white truncate">{a.title}</p>
                  <p className="text-xs text-on-surface-variant dark:text-white/60">
                    {a.users?.name ?? dm.anonymous} · {a.subject_name} · {a.score}/{a.total}
                  </p>
                </div>
                <span className="text-xs text-on-surface-variant dark:text-white/40">{new Date(a.created_at).toLocaleDateString()}</span>
              </div>
            ))}
          </div>
        ) : <p className="text-on-surface-variant dark:text-white/40 text-sm">{dm.noActivity}</p>}
      </div>
    </div>
  );
}
