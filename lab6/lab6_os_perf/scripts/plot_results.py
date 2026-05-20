#!/usr/bin/env python3
import csv
import math
import os
from collections import defaultdict
from statistics import mean, stdev

import matplotlib.pyplot as plt

ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
RESULTS_DIR = os.path.join(ROOT_DIR, 'results')
PLOTS_DIR = os.path.join(ROOT_DIR, 'plots')
os.makedirs(PLOTS_DIR, exist_ok=True)


def read_csv(path):
    by_n = defaultdict(list)
    rss_by_n = defaultdict(list)
    with open(path, newline='') as f:
        reader = csv.DictReader(f)
        for row in reader:
            n = int(row['n'])
            by_n[n].append(float(row['time_sec']))
            rss_by_n[n].append(int(row['max_rss_kb']))
    return by_n, rss_by_n


def summarize_file(path):
    by_n, rss_by_n = read_csv(path)
    rows = []
    for n in sorted(by_n):
        values = by_n[n]
        rss_values = rss_by_n[n]
        rows.append({
            'file': os.path.basename(path),
            'n': n,
            'avg_time_sec': mean(values),
            'std_time_sec': stdev(values) if len(values) > 1 else 0.0,
            'avg_max_rss_kb': mean(rss_values),
        })
    return rows


def plot_one(csv_path, rows):
    stem = os.path.splitext(os.path.basename(csv_path))[0]
    xs = [r['n'] for r in rows]
    ys = [r['avg_time_sec'] for r in rows]

    plt.figure(figsize=(9, 5))
    plt.plot(xs, ys, marker='o')
    plt.xlabel('N - number of tasks')
    plt.ylabel('Average total time, sec')
    plt.title(stem.replace('_', ' '))
    plt.grid(True)
    plt.xticks(xs)
    plt.tight_layout()

    out = os.path.join(PLOTS_DIR, f'{stem}.png')
    plt.savefig(out, dpi=160)
    plt.close()
    print(f'saved plot: {out}')


def write_summary(all_rows):
    out = os.path.join(RESULTS_DIR, 'summary.csv')
    with open(out, 'w', newline='') as f:
        fieldnames = ['file', 'n', 'avg_time_sec', 'std_time_sec', 'avg_max_rss_kb']
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in all_rows:
            writer.writerow(row)
    print(f'saved summary: {out}')


def plot_comparison(csv_files):
    groups = defaultdict(list)
    for path in csv_files:
        stem = os.path.splitext(os.path.basename(path))[0]
        parts = stem.split('_')
        if len(parts) != 3:
            continue
        workload, mode, cpu_label = parts
        groups[(workload, cpu_label)].append(path)

    for (workload, cpu_label), paths in sorted(groups.items()):
        if len(paths) < 2:
            continue
        plt.figure(figsize=(9, 5))
        for path in sorted(paths):
            rows = summarize_file(path)
            xs = [r['n'] for r in rows]
            ys = [r['avg_time_sec'] for r in rows]
            label = os.path.splitext(os.path.basename(path))[0].replace('_', ' ')
            plt.plot(xs, ys, marker='o', label=label)
        plt.xlabel('N - number of tasks')
        plt.ylabel('Average total time, sec')
        plt.title(f'{workload} comparison, {cpu_label}')
        plt.grid(True)
        plt.legend()
        plt.tight_layout()
        out = os.path.join(PLOTS_DIR, f'{workload}_comparison_{cpu_label}.png')
        plt.savefig(out, dpi=160)
        plt.close()
        print(f'saved comparison plot: {out}')


def main():
    csv_files = sorted(
        os.path.join(RESULTS_DIR, name)
        for name in os.listdir(RESULTS_DIR)
        if name.endswith('.csv') and name != 'summary.csv'
    )
    if not csv_files:
        raise SystemExit('No result CSV files found. Run scripts/benchmark.sh first.')

    all_rows = []
    for csv_path in csv_files:
        rows = summarize_file(csv_path)
        all_rows.extend(rows)
        plot_one(csv_path, rows)

    write_summary(all_rows)
    plot_comparison(csv_files)


if __name__ == '__main__':
    main()
