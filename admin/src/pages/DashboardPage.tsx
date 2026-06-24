import { useEffect, useState } from 'react';
import { Users, GraduationCap, BookOpen, MessageSquare, Star, RefreshCw } from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import StatCard from '../components/StatCard';
import { api } from '../lib/api';
import type { DashboardStats, ClassStats, AdminActivity } from '../lib/types';

export default function DashboardPage() {
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
    <div className="flex items-center justify-center h-96"><div className="animate-spin w-8 h-8 border-4 border-[#4F46E5] border-t-transparent rounded-full" /></div>
  );

  if (error) return (
    <div className="text-center py-20">
      <p className="text-red-500 mb-4">{error}</p>
      <button onClick={load} className="px-6 py-2 bg-[#4F46E5] text-white rounded-xl hover:bg-[#4338CA]">Réessayer</button>
    </div>
  );

  const chartData = classStats.map(cs => ({
    name: cs.className,
    Moyenne: cs.averageGrade,
    Élèves: cs.studentCount,
  }));

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-bold text-[#0D1B2A]">Tableau de bord</h1>
          <p className="text-gray-500 mt-1">Vue d'ensemble de la plateforme</p>
        </div>
        <button onClick={load} className="flex items-center gap-2 px-4 py-2 text-sm text-gray-600 hover:text-[#4F46E5] border border-gray-200 rounded-xl hover:border-[#4F46E5] transition-all">
          <RefreshCw size={16} /> Actualiser
        </button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
        <StatCard label="Utilisateurs" value={stats?.totalUsers ?? 0} icon={<Users size={22} />} color="#4F46E5" />
        <StatCard label="Étudiants" value={stats?.totalStudents ?? 0} icon={<GraduationCap size={22} />} color="#10B981" />
        <StatCard label="Enseignants" value={stats?.totalTeachers ?? 0} icon={<Users size={22} />} color="#4F46E5" subtitle={`${stats?.totalAdmins ?? 0} administrateurs`} />
        <StatCard label="Cours" value={stats?.totalCourses ?? 0} icon={<BookOpen size={22} />} color="#F59E0B" />
        <StatCard label="Moyenne générale" value={stats?.averageGrade ?? 0} icon={<Star size={22} />} color="#F59E0B" subtitle="/20" />
        <StatCard label="Messages" value={stats?.totalChatMessages ?? 0} icon={<MessageSquare size={22} />} color="#06B6D4" />
        <StatCard label="Activités (7j)" value={stats?.totalActivities ?? 0} icon={<RefreshCw size={22} />} color="#10B981" />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
        <div className="bg-white rounded-2xl p-6 border border-gray-100 shadow-sm">
          <h2 className="text-lg font-semibold text-[#0D1B2A] mb-4">Performance par classe</h2>
          {chartData.length > 0 ? (
            <ResponsiveContainer width="100%" height={250}>
              <BarChart data={chartData}>
                <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
                <XAxis dataKey="name" tick={{ fontSize: 12 }} />
                <YAxis domain={[0, 20]} tick={{ fontSize: 12 }} />
                <Tooltip />
                <Bar dataKey="Moyenne" fill="#4F46E5" radius={[6, 6, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          ) : <p className="text-gray-400 text-sm">Aucune donnée</p>}
        </div>

        <div className="bg-white rounded-2xl p-6 border border-gray-100 shadow-sm">
          <h2 className="text-lg font-semibold text-[#0D1B2A] mb-4">Classes</h2>
          <div className="space-y-3">
            {classStats.map(cs => {
              const color = cs.averageGrade >= 12 ? 'text-green-600' : cs.averageGrade >= 8 ? 'text-amber-600' : 'text-red-600';
              const bg = cs.averageGrade >= 12 ? 'bg-green-50' : cs.averageGrade >= 8 ? 'bg-amber-50' : 'bg-red-50';
              return (
                <div key={cs.className} className="flex items-center justify-between p-4 rounded-xl border border-gray-50 hover:shadow-sm transition-shadow">
                  <div>
                    <p className="font-medium text-[#0D1B2A]">{cs.className}</p>
                    <p className="text-sm text-gray-400">{cs.studentCount} élèves</p>
                  </div>
                  <div className={`px-3 py-1.5 rounded-lg ${bg}`}>
                    <span className={`font-bold ${color}`}>{cs.averageGrade}/20</span>
                  </div>
                </div>
              );
            })}
            {classStats.length === 0 && <p className="text-gray-400 text-sm">Aucune classe</p>}
          </div>
        </div>
      </div>

      <div className="bg-white rounded-2xl p-6 border border-gray-100 shadow-sm">
        <h2 className="text-lg font-semibold text-[#0D1B2A] mb-4">Activités récentes</h2>
        {activities.length > 0 ? (
          <div className="space-y-3">
            {activities.map(a => (
              <div key={a.id} className="flex items-center gap-4 p-3 rounded-xl hover:bg-gray-50 transition-colors">
                <div className={`w-10 h-10 rounded-xl flex items-center justify-center text-white text-sm font-bold ${
                  a.type === 'quiz' ? 'bg-amber-500' : a.type === 'exercice' ? 'bg-green-500' : 'bg-blue-500'
                }`}>
                  {a.type === 'quiz' ? 'Q' : a.type === 'exercice' ? 'E' : 'C'}
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium text-[#0D1B2A] truncate">{a.title}</p>
                  <p className="text-xs text-gray-400">
                    {a.users?.name ?? 'Anonyme'} · {a.subject_name} · {a.score}/{a.total}
                  </p>
                </div>
                <span className="text-xs text-gray-400">{new Date(a.created_at).toLocaleDateString('fr-FR')}</span>
              </div>
            ))}
          </div>
        ) : <p className="text-gray-400 text-sm">Aucune activité récente</p>}
      </div>
    </div>
  );
}
