#!/usr/bin/env python3
"""
Script para generar gráficos de análisis de speedup
Proyecto HPC - Multiplicación de Matrices con Hilos
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns

# Configurar estilo
plt.style.use('seaborn-v0_8')
sns.set_palette("husl")

# Datos del benchmark (extraídos del CSV)
data = {
    'Tamaño': [10, 10, 10, 10, 10, 100, 100, 100, 100, 100, 500, 500, 500, 500, 500, 1000, 1000],
    'Hilos': [1, 2, 4, 8, 16, 1, 2, 4, 8, 16, 1, 2, 4, 8, 16, 1, 8],
    'Speedup': [0.00, 0.00, 0.00, 0.00, 0.00, 1.20, 1.25, 1.67, 1.50, 1.80, 1.16, 1.19, 2.20, 2.72, 2.31, 0.82, 2.90],
    'Eficiencia': [0.0, 0.0, 0.0, 0.0, 0.0, 120.0, 62.5, 41.7, 18.8, 11.2, 116.1, 59.3, 55.1, 34.0, 14.4, 82.2, 36.3],
    'T_Secuencial': [0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0080, 0.0050, 0.0050, 0.0050, 0.0060, 1.0250, 0.6570, 0.7160, 0.6360, 0.6270, 6.7540, 7.0030],
    'T_Paralelo': [0.0003, 0.0007, 0.0007, 0.0007, 0.0017, 0.0067, 0.0040, 0.0030, 0.0033, 0.0033, 0.8827, 0.5540, 0.3250, 0.2340, 0.2720, 8.2160, 2.4113]
}

df = pd.DataFrame(data)

# Crear figura con múltiples subplots
fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(16, 12))

# Gráfico 1: Speedup vs Hilos por tamaño
sizes_to_plot = [100, 500, 1000]  # Excluir 10x10 (no tiene speedup significativo)
colors = ['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728']

for i, size in enumerate(sizes_to_plot):
    data_size = df[df['Tamaño'] == size]
    if not data_size.empty:
        ax1.plot(data_size['Hilos'], data_size['Speedup'], 'o-', 
                 label=f'{size}×{size}', linewidth=3, markersize=8, color=colors[i])

# Línea de speedup ideal
max_threads = 16
ax1.plot([1, max_threads], [1, max_threads], '--', color='gray', alpha=0.7, 
         linewidth=2, label='Speedup Ideal')

ax1.set_xlabel('Número de Hilos', fontsize=12, fontweight='bold')
ax1.set_ylabel('Speedup', fontsize=12, fontweight='bold')
ax1.set_title('Speedup vs Número de Hilos', fontsize=14, fontweight='bold')
ax1.legend(fontsize=10)
ax1.grid(True, alpha=0.3)
ax1.set_xlim(0.5, 16.5)
ax1.set_ylim(0, 4)

# Gráfico 2: Eficiencia vs Hilos  
for i, size in enumerate(sizes_to_plot):
    data_size = df[df['Tamaño'] == size]
    if not data_size.empty:
        ax2.plot(data_size['Hilos'], data_size['Eficiencia'], 's-', 
                 label=f'{size}×{size}', linewidth=3, markersize=8, color=colors[i])

ax2.set_xlabel('Número de Hilos', fontsize=12, fontweight='bold')
ax2.set_ylabel('Eficiencia (%)', fontsize=12, fontweight='bold')
ax2.set_title('Eficiencia vs Número de Hilos', fontsize=14, fontweight='bold')
ax2.legend(fontsize=10)
ax2.grid(True, alpha=0.3)
ax2.set_xlim(0.5, 16.5)
ax2.set_ylim(0, 130)

# Gráfico 3: Tiempos de ejecución (Secuencial vs Paralelo)
sizes_for_time = [100, 500, 1000]
thread_counts = [1, 4, 8]

for size in sizes_for_time:
    seq_times = []
    par_times = []
    threads = []
    
    for t in thread_counts:
        data_point = df[(df['Tamaño'] == size) & (df['Hilos'] == t)]
        if not data_point.empty:
            seq_times.append(data_point['T_Secuencial'].iloc[0])
            par_times.append(data_point['T_Paralelo'].iloc[0])
            threads.append(f"{size}×{size}\n{t}h")
    
    if seq_times:
        x = np.arange(len(threads))
        width = 0.35
        
        bars1 = ax3.bar(x - width/2, seq_times, width, label=f'Secuencial {size}×{size}', alpha=0.7)
        bars2 = ax3.bar(x + width/2, par_times, width, label=f'Paralelo {size}×{size}', alpha=0.7)

ax3.set_xlabel('Configuración (Tamaño - Hilos)', fontsize=12, fontweight='bold')
ax3.set_ylabel('Tiempo (segundos)', fontsize=12, fontweight='bold')
ax3.set_title('Comparación: Tiempo Secuencial vs Paralelo', fontsize=14, fontweight='bold')
ax3.legend(fontsize=9)
ax3.grid(True, alpha=0.3, axis='y')

# Gráfico 4: Heatmap de Speedup
speedup_matrix = np.zeros((len(sizes_to_plot), 5))  # 5 configuraciones de hilos
thread_labels = ['1', '2', '4', '8', '16']

for i, size in enumerate(sizes_to_plot):
    for j, threads in enumerate([1, 2, 4, 8, 16]):
        data_point = df[(df['Tamaño'] == size) & (df['Hilos'] == threads)]
        if not data_point.empty:
            speedup_matrix[i, j] = data_point['Speedup'].iloc[0]

im = ax4.imshow(speedup_matrix, cmap='RdYlGn', aspect='auto', interpolation='nearest')
ax4.set_xticks(range(5))
ax4.set_xticklabels(thread_labels)
ax4.set_yticks(range(len(sizes_to_plot)))
ax4.set_yticklabels([f'{size}×{size}' for size in sizes_to_plot])
ax4.set_xlabel('Número de Hilos', fontsize=12, fontweight='bold')
ax4.set_ylabel('Tamaño de Matriz', fontsize=12, fontweight='bold')
ax4.set_title('Mapa de Calor: Speedup por Configuración', fontsize=14, fontweight='bold')

# Agregar valores en el heatmap
for i in range(len(sizes_to_plot)):
    for j in range(5):
        text = ax4.text(j, i, f'{speedup_matrix[i, j]:.2f}', 
                       ha="center", va="center", color="black", fontweight='bold')

# Colorbar para el heatmap
cbar = plt.colorbar(im, ax=ax4)
cbar.set_label('Speedup', fontsize=12, fontweight='bold')

plt.tight_layout()
plt.savefig('analisis_speedup_matrices.png', dpi=300, bbox_inches='tight')
print("✅ Gráficos guardados como 'analisis_speedup_matrices.png'")

# Crear gráfico adicional: Comparación de rendimiento absoluto
fig2, ax = plt.subplots(1, 1, figsize=(12, 8))

# Calcular MFLOPS para las configuraciones principales
configs = [
    (100, 4, 0.0030),   # 100x100, 4 hilos
    (500, 8, 0.2340),   # 500x500, 8 hilos  
    (1000, 8, 2.4113),  # 1000x1000, 8 hilos
]

sizes = []
mflops = []
labels = []

for size, threads, time in configs:
    ops = 2 * size**3  # Operaciones de multiplicación de matrices
    mflops_val = (ops / time) / 1_000_000  # MFLOPS
    sizes.append(size)
    mflops.append(mflops_val)
    labels.append(f'{size}×{size}\n{threads} hilos')

bars = ax.bar(labels, mflops, color=['skyblue', 'lightgreen', 'lightcoral'], alpha=0.8)
ax.set_ylabel('MFLOPS (Millones de operaciones por segundo)', fontsize=12, fontweight='bold')
ax.set_title('Rendimiento Absoluto por Configuración Óptima', fontsize=14, fontweight='bold')
ax.grid(True, alpha=0.3, axis='y')

# Agregar valores en las barras
for bar, val in zip(bars, mflops):
    height = bar.get_height()
    ax.text(bar.get_x() + bar.get_width()/2., height + height*0.01,
            f'{val:.0f}', ha='center', va='bottom', fontweight='bold')

plt.tight_layout()
plt.savefig('rendimiento_absoluto.png', dpi=300, bbox_inches='tight')
print("✅ Gráfico de rendimiento guardado como 'rendimiento_absoluto.png'")

# Estadísticas finales
print("\n" + "="*50)
print("📊 ESTADÍSTICAS FINALES DEL BENCHMARK")
print("="*50)

valid_speedups = df[df['Speedup'] > 0]
print(f"🏆 Mejor speedup: {valid_speedups['Speedup'].max():.2f}x")
best_config = valid_speedups[valid_speedups['Speedup'] == valid_speedups['Speedup'].max()]
print(f"   Configuración: {best_config['Tamaño'].iloc[0]}×{best_config['Tamaño'].iloc[0]} con {best_config['Hilos'].iloc[0]} hilos")

print(f"\n📈 Speedup promedio (válido): {valid_speedups['Speedup'].mean():.2f}x")
print(f"🔧 Eficiencia promedio: {valid_speedups['Eficiencia'].mean():.1f}%")

print(f"\n⚡ Mejor configuración por tamaño:")
for size in [100, 500, 1000]:
    size_data = df[df['Tamaño'] == size]
    if not size_data.empty:
        best_idx = size_data['Speedup'].idxmax()
        best = size_data.loc[best_idx]
        print(f"   {size}×{size}: {best['Hilos']} hilos → {best['Speedup']:.2f}x speedup")

print("\n🎯 RECOMENDACIONES:")
print("   • Para matrices ≤200×200: usar 4 hilos")
print("   • Para matrices 500×500-1000×1000: usar 8 hilos")  
print("   • Para matrices ≥2000×2000: usar 4 hilos")
print("   • Speedup máximo esperado: ~3x con configuración óptima")

print(f"\n📁 Archivos generados:")
print(f"   • analisis_speedup_matrices.png")
print(f"   • rendimiento_absoluto.png")
print(f"   • analisis_speedup_completo.md")
print(f"   • resultados_completos.csv")
