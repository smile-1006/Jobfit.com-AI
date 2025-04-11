import React from 'react';
import { Layout } from './components/Layout';
import { Routes, Route } from 'react-router-dom';
import { Dashboard } from './pages/Dashboard';
import { JobPostings } from './pages/JobPostings';
import { Candidates } from './pages/Candidates';
import { Analytics } from './pages/Analytics';
import { Settings } from './pages/Settings';

function App() {
  return (
    <Layout>
      <Routes>
        <Route path="/" element={<Dashboard />} />
        <Route path="/jobs" element={<JobPostings />} />
        <Route path="/candidates" element={<Candidates />} />
        <Route path="/analytics" element={<Analytics />} />
        <Route path="/settings" element={<Settings />} />
      </Routes>
    </Layout>
  );
}

export default App;