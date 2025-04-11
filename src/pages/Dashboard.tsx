import React from 'react';
import { Users, Briefcase, Clock, Award } from 'lucide-react';

const stats = [
  { label: 'Active Candidates', value: '2,431', icon: Users, color: 'bg-blue-500' },
  { label: 'Open Positions', value: '48', icon: Briefcase, color: 'bg-green-500' },
  { label: 'Pending Reviews', value: '156', icon: Clock, color: 'bg-yellow-500' },
  { label: 'Successful Matches', value: '892', icon: Award, color: 'bg-purple-500' },
];

export function Dashboard() {
  return (
    <div>
      <h1 className="text-2xl font-semibold text-gray-900 mb-8">Dashboard</h1>
      
      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        {stats.map((stat) => {
          const Icon = stat.icon;
          return (
            <div key={stat.label} className="bg-white rounded-xl shadow-sm p-6">
              <div className="flex items-center gap-4">
                <div className={`${stat.color} p-3 rounded-lg`}>
                  <Icon className="w-6 h-6 text-white" />
                </div>
                <div>
                  <p className="text-sm text-gray-600">{stat.label}</p>
                  <p className="text-2xl font-semibold text-gray-900">{stat.value}</p>
                </div>
              </div>
            </div>
          );
        })}
      </div>

      {/* Recent Activity */}
      <div className="bg-white rounded-xl shadow-sm p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Recent Activity</h2>
        <div className="space-y-4">
          {[1, 2, 3].map((i) => (
            <div key={i} className="flex items-center gap-4 p-4 bg-gray-50 rounded-lg">
              <div className="w-10 h-10 bg-indigo-100 rounded-full flex items-center justify-center">
                <Users className="w-5 h-5 text-indigo-600" />
              </div>
              <div>
                <p className="text-sm font-medium text-gray-900">
                  New candidate application received
                </p>
                <p className="text-sm text-gray-600">
                  Senior Frontend Developer position • 2 hours ago
                </p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}