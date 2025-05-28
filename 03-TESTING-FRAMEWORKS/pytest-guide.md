# Pytest Master Guide - 2025 Edition

## Why Pytest? (2025 Landscape)

### Framework Comparison
```
Feature              Pytest    Unittest    Hypothesis   Robot
Ease of Use          ⭐⭐⭐⭐⭐    ⭐⭐⭐        ⭐⭐⭐⭐       ⭐⭐
Power/Flexibility    ⭐⭐⭐⭐⭐    ⭐⭐⭐        ⭐⭐⭐⭐⭐     ⭐⭐⭐
Plugin Ecosystem     ⭐⭐⭐⭐⭐    ⭐⭐         ⭐⭐⭐        ⭐⭐⭐⭐
Performance          ⭐⭐⭐⭐     ⭐⭐⭐⭐       ⭐⭐⭐        ⭐⭐
Community Support    ⭐⭐⭐⭐⭐    ⭐⭐⭐⭐       ⭐⭐⭐⭐       ⭐⭐⭐
```

**Pytest Advantages:**
- Simple, pythonic syntax
- Powerful fixtures system
- Excellent plugin ecosystem (800+ plugins)
- Automatic test discovery
- Detailed failure reporting
- Parallel execution support

## Installation & Setup

```bash
# Core pytest installation
pip install pytest pytest-cov pytest-xdist pytest-mock

# Additional useful plugins
pip install pytest-html pytest-json-report pytest-benchmark
pip install pytest-asyncio pytest-django pytest-flask

# With uv (fastest)
uv add --dev pytest pytest-cov pytest-xdist pytest-mock
```

## Basic Test Structure

### Simple Test Function
```python
# test_calculator.py
def add(a: int, b: int) -> int:
    return a + b

def test_add():
    """Test basic addition functionality."""
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
    assert add(0, 0) == 0

def test_add_with_floats():
    """Test addition with floating point numbers."""
    result = add(0.1, 0.2)
    assert abs(result - 0.3) < 1e-10  # Handle floating point precision
```

### Test Classes
```python
import pytest
from datetime import datetime

class TestUserAccount:
    """Test suite for UserAccount class."""
    
    def test_user_creation(self):
        """Test user account creation."""
        user = UserAccount("alice", "alice@example.com")
        assert user.username == "alice"
        assert user.email == "alice@example.com"
        assert user.is_active is True
    
    def test_user_deactivation(self):
        """Test user account deactivation."""
        user = UserAccount("bob", "bob@example.com")
        user.deactivate()
        assert user.is_active is False
    
    @pytest.mark.parametrize("username,email,expected_valid", [
        ("alice", "alice@example.com", True),
        ("", "alice@example.com", False),
        ("alice", "", False),
        ("alice", "invalid-email", False),
    ])
    def test_user_validation(self, username, email, expected_valid):
        """Test user validation with multiple inputs."""
        if expected_valid:
            user = UserAccount(username, email)
            assert user.is_valid()
        else:
            with pytest.raises(ValueError):
                UserAccount(username, email)
```

## Fixtures - The Power of Pytest

### Basic Fixtures
```python
import pytest
import tempfile
from pathlib import Path

@pytest.fixture
def temp_directory():
    """Create a temporary directory for testing."""
    with tempfile.TemporaryDirectory() as temp_dir:
        yield Path(temp_dir)

@pytest.fixture
def sample_user():
    """Create a sample user for testing."""
    return UserAccount("testuser", "test@example.com")

@pytest.fixture
def database_connection():
    """Setup database connection for testing."""
    conn = create_test_database()
    yield conn
    conn.close()
    cleanup_test_database()
```

### Fixture Scopes
```python
@pytest.fixture(scope="function")  # Default - new instance per test
def user():
    return UserAccount("test", "test@example.com")

@pytest.fixture(scope="class")  # One instance per test class
def database_session():
    session = create_session()
    yield session
    session.close()

@pytest.fixture(scope="module")  # One instance per test module
def api_client():
    client = APIClient()
    client.authenticate()
    yield client
    client.logout()

@pytest.fixture(scope="session")  # One instance per test session
def test_server():
    server = TestServer()
    server.start()
    yield server
    server.stop()
```

### Parametrized Fixtures
```python
@pytest.fixture(params=[
    {"driver": "sqlite", "host": ":memory:"},
    {"driver": "postgresql", "host": "localhost"},
    {"driver": "mysql", "host": "localhost"},
])
def database_config(request):
    """Parametrized database configuration."""
    return request.param

def test_database_operations(database_config):
    """Test will run once for each database configuration."""
    db = Database(**database_config)
    # Test database operations
    assert db.is_connected()
```

### Dependency Injection with Fixtures
```python
@pytest.fixture
def user_service(database_connection):
    """User service depends on database connection."""
    return UserService(database_connection)

@pytest.fixture
def email_service():
    """Mock email service for testing."""
    return MockEmailService()

@pytest.fixture
def user_manager(user_service, email_service):
    """User manager depends on multiple services."""
    return UserManager(user_service, email_service)

def test_user_registration(user_manager):
    """Test user registration with injected dependencies."""
    result = user_manager.register_user("alice", "alice@example.com")
    assert result.success is True
```

## Advanced Testing Patterns

### Parametrized Tests
```python
import pytest

@pytest.mark.parametrize("input,expected", [
    ("hello", "HELLO"),
    ("World", "WORLD"),
    ("123", "123"),
    ("", ""),
])
def test_uppercase(input, expected):
    """Test string uppercase conversion."""
    assert input.upper() == expected

@pytest.mark.parametrize("a,b,expected", [
    (1, 2, 3),
    (0, 0, 0),
    (-1, 1, 0),
    (100, 200, 300),
])
def test_addition(a, b, expected):
    """Test addition with multiple parameter sets."""
    assert add(a, b) == expected

# Complex parametrization
@pytest.mark.parametrize("user_data,expected_result", [
    ({"name": "Alice", "age": 25}, {"valid": True, "errors": []}),
    ({"name": "", "age": 25}, {"valid": False, "errors": ["Name required"]}),
    ({"name": "Bob", "age": -1}, {"valid": False, "errors": ["Age must be positive"]}),
])
def test_user_validation_complex(user_data, expected_result):
    """Test complex user validation scenarios."""
    result = validate_user(user_data)
    assert result["valid"] == expected_result["valid"]
    assert result["errors"] == expected_result["errors"]
```

### Exception Testing
```python
import pytest

def test_division_by_zero():
    """Test division by zero raises appropriate exception."""
    with pytest.raises(ZeroDivisionError):
        1 / 0

def test_value_error_with_message():
    """Test exception with specific message."""
    with pytest.raises(ValueError, match="Invalid input"):
        validate_input("invalid")

def test_multiple_exceptions():
    """Test function can raise multiple exception types."""
    with pytest.raises((ValueError, TypeError)):
        process_data(None)

def test_exception_info():
    """Test exception details."""
    with pytest.raises(CustomError) as exc_info:
        risky_operation()
    
    assert exc_info.value.error_code == 404
    assert "not found" in str(exc_info.value)
```

### Mocking and Patching
```python
import pytest
from unittest.mock import Mock, patch, MagicMock

def test_with_mock_object():
    """Test using mock objects."""
    mock_service = Mock()
    mock_service.get_data.return_value = {"id": 1, "name": "test"}
    
    result = process_service_data(mock_service)
    
    mock_service.get_data.assert_called_once()
    assert result["processed"] is True

@patch('requests.get')
def test_api_call(mock_get):
    """Test API call with mocked requests."""
    mock_response = Mock()
    mock_response.json.return_value = {"status": "success"}
    mock_response.status_code = 200
    mock_get.return_value = mock_response
    
    result = fetch_api_data("https://api.example.com")
    
    assert result["status"] == "success"
    mock_get.assert_called_once_with("https://api.example.com")

@pytest.fixture
def mock_database():
    """Mock database fixture."""
    with patch('myapp.database.get_connection') as mock_conn:
        mock_conn.return_value = MagicMock()
        yield mock_conn.return_value
```

### Async Testing
```python
import pytest
import asyncio

@pytest.mark.asyncio
async def test_async_function():
    """Test asynchronous function."""
    result = await async_fetch_data()
    assert result is not None

@pytest.mark.asyncio
async def test_async_with_timeout():
    """Test async function with timeout."""
    with pytest.raises(asyncio.TimeoutError):
        await asyncio.wait_for(slow_async_function(), timeout=1.0)

@pytest.fixture
async def async_client():
    """Async fixture for HTTP client."""
    async with httpx.AsyncClient() as client:
        yield client
```

## Test Organization

### Directory Structure
```
project/
├── src/
│   └── myapp/
│       ├── __init__.py
│       ├── models.py
│       └── services.py
├── tests/
│   ├── __init__.py
│   ├── conftest.py          # Shared fixtures
│   ├── unit/                # Unit tests
│   │   ├── test_models.py
│   │   └── test_services.py
│   ├── integration/         # Integration tests
│   │   └── test_api.py
│   └── e2e/                 # End-to-end tests
│       └── test_workflows.py
└── pyproject.toml
```

### conftest.py - Shared Configuration
```python
# tests/conftest.py
import pytest
from myapp import create_app
from myapp.database import init_db

@pytest.fixture(scope="session")
def app():
    """Create application for testing."""
    app = create_app(testing=True)
    with app.app_context():
        init_db()
        yield app

@pytest.fixture
def client(app):
    """Create test client."""
    return app.test_client()

@pytest.fixture(autouse=True)
def clean_database():
    """Automatically clean database after each test."""
    yield
    # Cleanup code runs after each test
    clear_all_tables()

# Test markers
def pytest_configure(config):
    """Configure pytest markers."""
    config.addinivalue_line("markers", "slow: marks tests as slow")
    config.addinivalue_line("markers", "integration: marks tests as integration")
    config.addinivalue_line("markers", "unit: marks tests as unit tests")
```

## Test Markers and Categories

```python
import pytest

@pytest.mark.unit
def test_pure_function():
    """Fast unit test."""
    assert pure_calculation(5) == 25

@pytest.mark.integration
def test_database_integration():
    """Integration test with database."""
    user = create_user_in_db("test")
    assert user.id is not None

@pytest.mark.slow
def test_expensive_operation():
    """Slow test that takes time."""
    result = expensive_computation()
    assert result is not None

@pytest.mark.skip(reason="Feature not implemented yet")
def test_future_feature():
    """Test for future feature."""
    pass

@pytest.mark.skipif(sys.platform == "win32", reason="Unix only test")
def test_unix_specific():
    """Test that only runs on Unix systems."""
    pass

@pytest.mark.xfail(reason="Known bug in external library")
def test_known_failure():
    """Test expected to fail."""
    assert broken_function() == "expected"
```

## Coverage and Reporting

### Coverage Configuration
```toml
# pyproject.toml
[tool.coverage.run]
source = ["src"]
omit = [
    "*/tests/*",
    "*/migrations/*",
    "*/__pycache__/*",
    "*/venv/*"
]
branch = true

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise AssertionError",
    "raise NotImplementedError",
    "if __name__ == .__main__.:",
    "if TYPE_CHECKING:",
]
show_missing = true
precision = 2
fail_under = 80

[tool.coverage.html]
directory = "htmlcov"
```

### Running Tests with Coverage
```bash
# Basic coverage
pytest --cov=src

# HTML coverage report
pytest --cov=src --cov-report=html

# XML coverage (for CI)
pytest --cov=src --cov-report=xml

# Coverage with missing lines
pytest --cov=src --cov-report=term-missing

# Fail if coverage below threshold
pytest --cov=src --cov-fail-under=80
```

## Performance Testing

### Benchmarking with pytest-benchmark
```python
import pytest

def fibonacci(n):
    """Calculate fibonacci number."""
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

def test_fibonacci_performance(benchmark):
    """Benchmark fibonacci calculation."""
    result = benchmark(fibonacci, 10)
    assert result == 55

@pytest.mark.parametrize("n", [5, 10, 15, 20])
def test_fibonacci_scaling(benchmark, n):
    """Test fibonacci performance scaling."""
    benchmark(fibonacci, n)
```

### Memory Profiling
```python
import pytest
from memory_profiler import profile

@profile
def test_memory_usage():
    """Test memory usage of function."""
    data = create_large_dataset()
    result = process_dataset(data)
    assert len(result) > 0
```

## Advanced Configuration

### pytest.ini
```ini
[tool:pytest]
minversion = 6.0
addopts = 
    --strict-markers
    --strict-config
    --cov=src
    --cov-report=term-missing
    --cov-report=html
    --cov-report=xml
    --cov-fail-under=80
    --tb=short
testpaths = tests
markers =
    slow: marks tests as slow (deselect with '-m "not slow"')
    integration: marks tests as integration tests
    unit: marks tests as unit tests
    smoke: marks tests as smoke tests
filterwarnings =
    ignore::UserWarning
    ignore::DeprecationWarning
```

### Advanced Test Selection
```bash
# Run only unit tests
pytest -m unit

# Run everything except slow tests
pytest -m "not slow"

# Run integration and unit tests
pytest -m "integration or unit"

# Run tests matching pattern
pytest -k "test_user"

# Run tests in specific file
pytest tests/test_models.py

# Run specific test
pytest tests/test_models.py::test_user_creation

# Run with maximum verbosity
pytest -vvv

# Stop on first failure
pytest -x

# Run last failed tests
pytest --lf

# Run failed tests first
pytest --ff
```

## Continuous Integration

### GitHub Actions Example
```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: [3.12, 3.13]
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v4
      with:
        python-version: ${{ matrix.python-version }}
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -e ".[dev]"
    
    - name: Run tests
      run: |
        pytest --cov=src --cov-report=xml
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage.xml
```

## Best Practices Summary

### Test Writing Guidelines
1. **One assertion per test** (when possible)
2. **Descriptive test names** that explain intent
3. **Use fixtures** for setup/teardown
4. **Mock external dependencies**
5. **Test edge cases** and error conditions
6. **Keep tests fast** and independent
7. **Use parametrized tests** for multiple inputs
8. **Organize tests** by feature/module

### Performance Tips
```bash
# Parallel execution
pytest -n auto  # Uses all CPU cores
pytest -n 4     # Uses 4 cores

# Disable coverage for faster runs during development
pytest --no-cov

# Run only changed tests
pytest --testmon

# Profile test execution time
pytest --durations=10
```

---

**Master Goal**: Write tests that serve as documentation, catch regressions, and give confidence to refactor. Aim for 90%+ coverage on critical code paths.
