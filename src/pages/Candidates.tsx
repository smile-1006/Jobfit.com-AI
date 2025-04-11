import React from 'react';
import { FileUpload } from '../components/FileUpload';
import { Users, Filter, Download } from 'lucide-react';

export function Candidates() {
  const handleFileUpload = (files: File[]) => {
    // TODO: Implement file upload logic with Supabase storage
    console.log('Uploaded files:', files);
  };

  const candidates = [
    {
      id: 1,
      name: 'Sarah Wilson',
      role: 'Senior Frontend Developer',
      matchScore: 92,
      status: 'Shortlisted',
      appliedDate: '2024-03-10',
    },
    {
      id: 2,
      name: 'Michael Chen',
      role: 'Product Manager',
      matchScore: 88,
      status: 'In Review',
      appliedDate: '2024-03-09',
    },
    {
      id: 3,
      name: 'Emily Rodriguez',
      role: 'UX Designer',
      matchScore: 85,
      status: 'New',
      appliedDate: '2024-03-08',
    },
  ];

  return (
    <div>
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-2xl font-semibold text-gray-900">Candidates</h1>
        <div className="flex gap-4">
          <button className="flex items-center gap-2 px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50">
            <Filter size={20} />
            <span>Filter</span>
          </button>
          <button className="flex items-center gap-2 px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50">
            <Download size={20} />
            <span>Export</span>
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 gap-6">
        <div className="bg-white rounded-xl shadow-sm p-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Upload Resumes</h2>
          <FileUpload
            onUpload={handleFileUpload}
            accept={{
              'application/pdf': ['.pdf'],
              'application/msword': ['.doc'],
              'application/vnd.openxmlformats-officedocument.wordprocessingml.document': ['.docx'],
            }}
          />
        </div>

        <div className="bg-white rounded-xl shadow-sm overflow-hidden">
          <div className="px-6 py-4 border-b border-gray-200">
            <h2 className="text-lg font-semibold text-gray-900">Recent Candidates</h2>
          </div>
          <div className="divide-y divide-gray-200">
            {candidates.map((candidate) => (
              <div key={candidate.id} className="p-6 hover:bg-gray-50 cursor-pointer">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-4">
                    <div className="w-12 h-12 bg-indigo-100 rounded-full flex items-center justify-center">
                      <Users className="w-6 h-6 text-indigo-600" />
                    </div>
                    <div>
                      <h3 className="text-sm font-medium text-gray-900">{candidate.name}</h3>
                      <p className="text-sm text-gray-500">{candidate.role}</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-6">
                    <div className="text-right">
                      <p className="text-sm font-medium text-gray-900">Match Score</p>
                      <p className="text-sm text-gray-500">{candidate.matchScore}%</p>
                    </div>
                    <div className="text-right">
                      <p className="text-sm font-medium text-gray-900">Status</p>
                      <p className="text-sm text-gray-500">{candidate.status}</p>
                    </div>
                    <div className="text-right">
                      <p className="text-sm font-medium text-gray-900">Applied</p>
                      <p className="text-sm text-gray-500">{candidate.appliedDate}</p>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}