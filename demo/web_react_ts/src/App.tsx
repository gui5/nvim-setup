import React, { useState } from "react";

interface CounterProps {
  initialCount?: number;
  label: string;
}

export const Counter: React.FC<CounterProps> = ({ initialCount = 0, label }) => {
  const [count, setCount] = useState<number>(initialCount);

  return (
    <div className="p-6 max-w-md mx-auto bg-slate-900 rounded-xl shadow-lg flex flex-col items-center space-y-4 border border-slate-700">
      <h2 className="text-xl font-bold text-sky-400">{label}</h2>
      <p className="text-3xl font-extrabold text-white">{count}</p>
      <div className="flex space-x-3">
        <button
          className="px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white font-medium rounded-lg transition"
          onClick={() => setCount((prev) => prev + 1)}
        >
          Increment
        </button>
        <button
          className="px-4 py-2 bg-rose-600 hover:bg-rose-500 text-white font-medium rounded-lg transition"
          onClick={() => setCount((prev) => prev - 1)}
        >
          Decrement
        </button>
        <button
          className="px-4 py-2 bg-slate-700 hover:bg-slate-600 text-slate-300 font-medium rounded-lg transition"
          onClick={() => setCount(0)}
        >
          Reset
        </button>
      </div>
    </div>
  );
};

export default function App() {
  return (
    <main className="min-h-screen bg-slate-950 flex flex-col items-center justify-center p-8 text-white">
      <header className="mb-8 text-center">
        <h1 className="text-4xl font-black tracking-tight text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 to-blue-600">
          Neovim 0.12 React + TypeScript
        </h1>
        <p className="mt-2 text-slate-400">
          Tailwind CSS & TypeScript LSP Integration
        </p>
      </header>
      <Counter label="Interactive State Counter" initialCount={10} />
    </main>
  );
}
