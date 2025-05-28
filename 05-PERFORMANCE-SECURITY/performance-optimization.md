# Python Performance Optimization - 2025 Guide

## Performance Mindset

### Core Principles
1. **Measure first** - Profile before optimizing
2. **Optimize bottlenecks** - Focus on what matters
3. **Algorithm > Micro-optimizations** - Big O wins
4. **Memory matters** - Consider memory usage patterns
5. **Async for I/O** - Use async/await for I/O bound tasks

## Profiling Tools

### Built-in Profilers
```python
import cProfile
import pstats
from pstats import SortKey

# Profile a function
def profile_function():
    """Example function to profile."""
    data = list(range(1000000))
    result = [x * 2 for x in data if x % 2 == 0]
    return result

# Basic profiling
cProfile.run('profile_function()', 'profile_results.prof')

# Analyze results
stats = pstats.Stats('profile_results.prof')
stats.sort_stats(SortKey.CUMULATIVE)
stats.print_stats(10)  # Top 10 functions

# Profile specific code block
import cProfile
pr = cProfile.Profile()
pr.enable()

# Your code here
result = expensive_function()

pr.disable()
pr.print_stats(sort='tottime')
```

### Line Profiler
```python
# Install: pip install line_profiler
# Usage: kernprof -l -v script.py

@profile
def slow_function():
    """Function to profile line by line."""
    total = 0
    for i in range(10000):  # Line-by-line timing
        total += i * i      # Will show time per line
    return total

# Memory profiler
# Install: pip install memory_profiler
from memory_profiler import profile

@profile
def memory_heavy_function():
    """Function to profile memory usage."""
    data = [i for i in range(1000000)]  # Memory allocation
    processed = [x * 2 for x in data]   # More memory
    return sum(processed)               # Peak memory usage
```

### Modern Profiling with py-spy
```bash
# Install: pip install py-spy
# Profile running Python process
py-spy record -o profile.svg --pid 1234

# Profile for 30 seconds
py-spy record -o profile.svg --duration 30 -- python my_script.py

# Top-like interface
py-spy top --pid 1234
```

## Built-in Optimizations

### Use Built-in Functions
```python
import operator
from functools import reduce
from itertools import chain, groupby, combinations

# Use built-ins instead of loops
def slow_operations():
    numbers = list(range(1000000))
    
    # Slow: manual loop
    total = 0
    for num in numbers:
        total += num
    
    # Slow: manual max finding
    maximum = numbers[0]
    for num in numbers:
        if num > maximum:
            maximum = num
    
    return total, maximum

def fast_operations():
    numbers = list(range(1000000))
    
    # Fast: built-in functions
    total = sum(numbers)      # Optimized C implementation
    maximum = max(numbers)    # Optimized C implementation
    
    return total, maximum

# Use map, filter, reduce appropriately
def functional_operations(data: List[int]) -> int:
    # Chain operations efficiently
    result = reduce(
        operator.add,
        map(lambda x: x * x,
            filter(lambda x: x % 2 == 0, data)),
        0
    )
    return result

# List comprehensions vs loops
def comprehension_vs_loop():
    # Faster: list comprehension
    squares = [x * x for x in range(1000)]
    
    # Slower: manual loop
    squares_manual = []
    for x in range(1000):
        squares_manual.append(x * x)
    
    return squares
```

### Collections Module Optimizations
```python
from collections import defaultdict, Counter, deque, namedtuple
from typing import Dict, List, Tuple

# Use defaultdict to avoid key checking
def slow_grouping(items: List[Tuple[str, int]]) -> Dict[str, List[int]]:
    groups = {}
    for key, value in items:
        if key not in groups:
            groups[key] = []
        groups[key].append(value)
    return groups

def fast_grouping(items: List[Tuple[str, int]]) -> Dict[str, List[int]]:
    groups = defaultdict(list)
    for key, value in items:
        groups[key].append(value)  # No key checking needed
    return dict(groups)

# Use Counter for counting operations
def slow_counting(items: List[str]) -> Dict[str, int]:
    counts = {}
    for item in items:
        counts[item] = counts.get(item, 0) + 1
    return counts

def fast_counting(items: List[str]) -> Counter:
    return Counter(items)  # Optimized C implementation

# Use namedtuple for structured data
class SlowPoint:
    def __init__(self, x: float, y: float):
        self.x = x
        self.y = y

# Faster and more memory efficient
FastPoint = namedtuple('Point', ['x', 'y'])

def point_operations():
    # namedtuple is faster for creation and access
    points = [FastPoint(i, i+1) for i in range(100000)]
    return sum(p.x + p.y for p in points)
```

## NumPy and Scientific Computing

### NumPy Vectorization
```python
import numpy as np
import math
from typing import List

# Avoid Python loops with NumPy arrays
def slow_math_operations(data: List[float]) -> List[float]:
    """Pure Python - slow for large datasets."""
    return [math.sqrt(x * x + 1) for x in data]

def fast_math_operations(data: np.ndarray) -> np.ndarray:
    """NumPy vectorized - much faster."""
    return np.sqrt(data * data + 1)

# Broadcasting for element-wise operations
def matrix_operations():
    # Create large arrays
    a = np.random.random((1000, 1000))
    b = np.random.random((1000, 1000))
    
    # Vectorized operations (fast)
    result = np.sqrt(a * a + b * b)
    
    # Avoid nested loops for array operations
    return result

# Use NumPy functions instead of Python equivalents
def statistical_operations(data: np.ndarray):
    # Fast NumPy functions
    mean = np.mean(data)
    std = np.std(data)
    median = np.median(data)
    
    # Use axis parameter for multi-dimensional arrays
    column_means = np.mean(data, axis=0)
    row_means = np.mean(data, axis=1)
    
    return mean, std, median, column_means, row_means
```

### Memory Layout Optimization
```python
import numpy as np

def memory_layout_optimization():
    # Row-major vs column-major access patterns
    data = np.random.random((10000, 10000))
    
    # Fast: row-wise access (C-style)
    row_sums = np.sum(data, axis=1)
    
    # Slower: column-wise access patterns
    # Use .T or axis parameters to optimize
    col_sums = np.sum(data, axis=0)
    
    # In-place operations to save memory
    data *= 2  # Instead of data = data * 2
    data += 1  # Instead of data = data + 1
    
    return row_sums, col_sums

def efficient_array_operations():
    # Pre-allocate arrays when possible
    result = np.empty((10000, 10000))  # Faster than append/grow
    
    # Use views instead of copies
    subset = result[1000:2000, 1000:2000]  # View, not copy
    copy_subset = result[1000:2000, 1000:2000].copy()  # Explicit copy
    
    # Efficient data type selection
    int_data = np.array(range(1000000), dtype=np.int32)  # vs int64
    float_data = np.array(range(1000000), dtype=np.float32)  # vs float64
    
    return result
```

## Cython and C Extensions

### Cython Optimization
```python
# setup.py for Cython
from setuptools import setup
from Cython.Build import cythonize

setup(
    ext_modules = cythonize("fast_math.pyx")
)

# fast_math.pyx - Cython code
import cython
import numpy as np
cimport numpy as cnp

@cython.boundscheck(False)
@cython.wraparound(False)
def fast_distance_calculation(cnp.double_t[:, :] points1, 
                             cnp.double_t[:, :] points2):
    """Cython optimized distance calculation."""
    cdef int n1 = points1.shape[0]
    cdef int n2 = points2.shape[0]
    cdef cnp.double_t[:, :] distances = np.empty((n1, n2))
    cdef int i, j
    cdef double dx, dy, dist
    
    for i in range(n1):
        for j in range(n2):
            dx = points1[i, 0] - points2[j, 0]
            dy = points1[i, 1] - points2[j, 1]
            distances[i, j] = (dx * dx + dy * dy) ** 0.5
    
    return np.asarray(distances)

# Pure Python equivalent (much slower)
def slow_distance_calculation(points1, points2):
    distances = []
    for p1 in points1:
        row = []
        for p2 in points2:
            dx = p1[0] - p2[0]
            dy = p1[1] - p2[1]
            dist = (dx * dx + dy * dy) ** 0.5
            row.append(dist)
        distances.append(row)
    return distances
```

## Database and I/O Optimization

### Database Query Optimization
```python
import sqlite3
from contextlib import contextmanager
from typing import List, Tuple, Iterator

@contextmanager
def database_connection(db_path: str):
    """Context manager for database connections."""
    conn = sqlite3.connect(db_path)
    try:
        yield conn
    finally:
        conn.close()

def slow_database_operations():
    """Inefficient database operations."""
    with database_connection("example.db") as conn:
        cursor = conn.cursor()
        
        # Slow: multiple individual inserts
        for i in range(1000):
            cursor.execute("INSERT INTO users (name) VALUES (?)", (f"user{i}",))
            conn.commit()  # Committing each insert

def fast_database_operations():
    """Optimized database operations."""
    with database_connection("example.db") as conn:
        cursor = conn.cursor()
        
        # Fast: batch insert with executemany
        users = [(f"user{i}",) for i in range(1000)]
        cursor.executemany("INSERT INTO users (name) VALUES (?)", users)
        conn.commit()  # Single commit
        
        # Use indexes for frequent queries
        cursor.execute("CREATE INDEX IF NOT EXISTS idx_users_name ON users(name)")

def efficient_query_patterns():
    """Efficient database query patterns."""
    with database_connection("example.db") as conn:
        cursor = conn.cursor()
        
        # Use LIMIT for large result sets
        cursor.execute("SELECT * FROM users LIMIT 100")
        
        # Use prepared statements for repeated queries
        cursor.execute("PREPARE stmt AS SELECT * FROM users WHERE age > ?")
        
        # Fetch in batches for large datasets
        cursor.execute("SELECT * FROM large_table")
        while True:
            rows = cursor.fetchmany(1000)
            if not rows:
                break
            process_batch(rows)
```

### File I/O Optimization
```python
import os
from pathlib import Path
from typing import Iterator

def slow_file_processing(filename: str) -> List[str]:
    """Inefficient file reading."""
    lines = []
    with open(filename, 'r') as f:
        for line in f:
            lines.append(line.strip().upper())
    return lines

def fast_file_processing(filename: str) -> Iterator[str]:
    """Memory-efficient file processing."""
    with open(filename, 'r') as f:
        for line in f:
            yield line.strip().upper()

def efficient_file_operations():
    """Various file operation optimizations."""
    
    # Use pathlib for path operations
    file_path = Path("data") / "large_file.txt"
    
    # Read entire file if it fits in memory
    if file_path.stat().st_size < 100 * 1024 * 1024:  # 100MB
        content = file_path.read_text()
    else:
        # Process line by line for large files
        with file_path.open() as f:
            for line in f:
                process_line(line)
    
    # Use appropriate buffer sizes
    with open(file_path, 'rb', buffering=8192) as f:
        while True:
            chunk = f.read(8192)
            if not chunk:
                break
            process_chunk(chunk)

def batch_file_operations(file_paths: List[Path]):
    """Batch process multiple files efficiently."""
    for file_path in file_paths:
        if not file_path.exists():
            continue
            
        # Process files based on size
        file_size = file_path.stat().st_size
        
        if file_size < 1024 * 1024:  # Small files
            content = file_path.read_text()
            process_small_file(content)
        else:  # Large files
            with file_path.open() as f:
                for chunk in iter(lambda: f.read(4096), ''):
                    process_chunk(chunk)
```

## Memory Management

### Memory Profiling and Optimization
```python
import gc
import sys
import weakref
from typing import Any, Dict, List

def memory_monitoring():
    """Monitor memory usage patterns."""
    
    # Force garbage collection
    gc.collect()
    
    # Check reference counts
    obj = [1, 2, 3]
    print(f"Reference count: {sys.getrefcount(obj)}")
    
    # Monitor object creation
    before = len(gc.get_objects())
    data = create_large_data_structure()
    after = len(gc.get_objects())
    print(f"Objects created: {after - before}")
    
    # Use weak references to avoid circular references
    cache = weakref.WeakValueDictionary()
    
    return data

class MemoryEfficientClass:
    """Example of memory-efficient class design."""
    __slots__ = ['_data', '_computed_cache']
    
    def __init__(self, data: List[int]):
        self._data = data
        self._computed_cache = None
    
    @property
    def computed_value(self) -> int:
        """Lazy computation with caching."""
        if self._computed_cache is None:
            self._computed_cache = sum(x * x for x in self._data)
        return self._computed_cache
    
    def clear_cache(self):
        """Manual cache clearing for memory management."""
        self._computed_cache = None

def object_pooling_example():
    """Object pooling for expensive-to-create objects."""
    
    class ExpensiveObject:
        def __init__(self):
            self.data = [0] * 10000  # Expensive to create
        
        def reset(self):
            """Reset object state for reuse."""
            self.data = [0] * 10000
    
    class ObjectPool:
        def __init__(self, factory, max_size=10):
            self.factory = factory
            self.pool = []
            self.max_size = max_size
        
        def acquire(self):
            if self.pool:
                return self.pool.pop()
            return self.factory()
        
        def release(self, obj):
            if len(self.pool) < self.max_size:
                obj.reset()
                self.pool.append(obj)
    
    # Usage
    pool = ObjectPool(ExpensiveObject)
    
    # Reuse objects instead of creating new ones
    obj = pool.acquire()
    # Use object...
    pool.release(obj)
```

## Benchmarking and Testing Performance

### Performance Testing Framework
```python
import time
import statistics
from typing import Callable, List, Any
from contextlib import contextmanager

@contextmanager
def timer():
    """Simple timing context manager."""
    start = time.perf_counter()
    yield
    end = time.perf_counter()
    print(f"Execution time: {end - start:.4f} seconds")

def benchmark_function(func: Callable, *args, runs: int = 10, **kwargs) -> Dict[str, float]:
    """Comprehensive function benchmarking."""
    times = []
    
    for _ in range(runs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        end = time.perf_counter()
        times.append(end - start)
    
    return {
        'mean': statistics.mean(times),
        'median': statistics.median(times),
        'stdev': statistics.stdev(times) if len(times) > 1 else 0,
        'min': min(times),
        'max': max(times)
    }

def performance_comparison():
    """Compare different implementations."""
    data = list(range(100000))
    
    # Test different approaches
    approaches = {
        'list_comprehension': lambda: [x * 2 for x in data],
        'map_function': lambda: list(map(lambda x: x * 2, data)),
        'manual_loop': lambda: manual_loop_double(data),
    }
    
    results = {}
    for name, func in approaches.items():
        results[name] = benchmark_function(func, runs=5)
        print(f"{name}: {results[name]['mean']:.4f}s ± {results[name]['stdev']:.4f}s")
    
    return results

def manual_loop_double(data: List[int]) -> List[int]:
    """Manual loop implementation for comparison."""
    result = []
    for x in data:
        result.append(x * 2)
    return result

# Memory benchmarking
import tracemalloc

def memory_benchmark(func: Callable, *args, **kwargs) -> tuple[Any, int]:
    """Benchmark memory usage of a function."""
    tracemalloc.start()
    
    result = func(*args, **kwargs)
    
    current, peak = tracemalloc.get_traced_memory()
    tracemalloc.stop()
    
    print(f"Current memory usage: {current / 1024 / 1024:.2f} MB")
    print(f"Peak memory usage: {peak / 1024 / 1024:.2f} MB")
    
    return result, peak
```

## Performance Best Practices Summary

### General Rules
1. **Profile first** - Use cProfile, py-spy, line_profiler
2. **Algorithm matters most** - O(n) vs O(n²) beats micro-optimizations
3. **Use appropriate data structures** - set for membership, deque for queues
4. **Leverage built-ins** - sum(), max(), map(), filter()
5. **Consider memory patterns** - generators for large datasets
6. **Async for I/O** - threading/multiprocessing for CPU-bound

### Quick Wins
- Replace loops with list comprehensions
- Use collections.defaultdict and Counter
- Cache expensive computations with @lru_cache
- Use NumPy for numerical computations
- Batch database operations
- Use appropriate string methods (join vs +=)

### When to Optimize
- When profiling shows clear bottlenecks
- When performance requirements aren't met
- When memory usage is problematic
- When scaling reveals issues

### When NOT to Optimize
- Before measuring (premature optimization)
- When code becomes unreadable
- When gains are negligible
- When it increases complexity significantly

---

**Remember**: "Premature optimization is the root of all evil" - Donald Knuth. Always measure before optimizing, and prioritize code clarity unless performance is critical.
