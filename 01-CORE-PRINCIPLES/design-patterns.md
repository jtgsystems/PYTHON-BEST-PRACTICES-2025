# Python Design Patterns - 2025 Edition

## Creational Patterns

### Singleton Pattern
```python
class DatabaseConnection:
    """Thread-safe singleton for database connections."""
    _instance = None
    _lock = threading.Lock()
    
    def __new__(cls):
        if cls._instance is None:
            with cls._lock:
                if cls._instance is None:
                    cls._instance = super().__new__(cls)
        return cls._instance
    
    def __init__(self):
        if not hasattr(self, 'initialized'):
            self.connection = self._create_connection()
            self.initialized = True

# Modern alternative using module-level
# connection.py
_connection = None

def get_connection():
    global _connection
    if _connection is None:
        _connection = create_connection()
    return _connection
```

### Factory Pattern
```python
from abc import ABC, abstractmethod
from typing import Protocol

class PaymentProcessor(Protocol):
    def process_payment(self, amount: float) -> bool: ...

class StripeProcessor:
    def process_payment(self, amount: float) -> bool:
        print(f"Processing ${amount} via Stripe")
        return True

class PayPalProcessor:
    def process_payment(self, amount: float) -> bool:
        print(f"Processing ${amount} via PayPal")
        return True

class PaymentFactory:
    @staticmethod
    def create_processor(provider: str) -> PaymentProcessor:
        processors = {
            'stripe': StripeProcessor,
            'paypal': PayPalProcessor,
        }
        processor_class = processors.get(provider.lower())
        if not processor_class:
            raise ValueError(f"Unknown payment provider: {provider}")
        return processor_class()
```

### Builder Pattern
```python
from dataclasses import dataclass, field
from typing import Optional

@dataclass
class DatabaseConfig:
    host: str = "localhost"
    port: int = 5432
    database: str = ""
    username: str = ""
    password: str = ""
    ssl_mode: str = "require"
    connection_timeout: int = 30
    pool_size: int = 10

class DatabaseConfigBuilder:
    def __init__(self):
        self._config = DatabaseConfig()
    
    def host(self, host: str) -> 'DatabaseConfigBuilder':
        self._config.host = host
        return self
    
    def port(self, port: int) -> 'DatabaseConfigBuilder':
        self._config.port = port
        return self
    
    def database(self, database: str) -> 'DatabaseConfigBuilder':
        self._config.database = database
        return self
    
    def credentials(self, username: str, password: str) -> 'DatabaseConfigBuilder':
        self._config.username = username
        self._config.password = password
        return self
    
    def ssl(self, enabled: bool = True) -> 'DatabaseConfigBuilder':
        self._config.ssl_mode = "require" if enabled else "disable"
        return self
    
    def build(self) -> DatabaseConfig:
        if not self._config.database:
            raise ValueError("Database name is required")
        return self._config

# Usage
config = (DatabaseConfigBuilder()
          .host("prod-db.example.com")
          .port(5432)
          .database("myapp")
          .credentials("user", "pass")
          .ssl(True)
          .build())
```

## Structural Patterns

### Adapter Pattern
```python
class LegacyPaymentSystem:
    def make_payment(self, amount_cents: int) -> dict:
        return {
            "transaction_id": f"TXN{amount_cents}",
            "status_code": 200,
            "amount": amount_cents
        }

class ModernPaymentInterface(Protocol):
    def process_payment(self, amount: float) -> bool: ...

class LegacyPaymentAdapter:
    def __init__(self, legacy_system: LegacyPaymentSystem):
        self._legacy_system = legacy_system
    
    def process_payment(self, amount: float) -> bool:
        amount_cents = int(amount * 100)
        result = self._legacy_system.make_payment(amount_cents)
        return result["status_code"] == 200
```

### Decorator Pattern
```python
import functools
import time
from typing import Callable, Any

def retry(max_attempts: int = 3, delay: float = 1.0):
    """Decorator to retry function calls on failure."""
    def decorator(func: Callable) -> Callable:
        @functools.wraps(func)
        def wrapper(*args, **kwargs) -> Any:
            last_exception = None
            for attempt in range(max_attempts):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    last_exception = e
                    if attempt < max_attempts - 1:
                        time.sleep(delay)
                    continue
            raise last_exception
        return wrapper
    return decorator

def cache_result(ttl_seconds: int = 300):
    """Decorator to cache function results."""
    def decorator(func: Callable) -> Callable:
        cache = {}
        
        @functools.wraps(func)
        def wrapper(*args, **kwargs) -> Any:
            # Create cache key from arguments
            key = str(args) + str(sorted(kwargs.items()))
            current_time = time.time()
            
            # Check if cached result exists and is still valid
            if key in cache:
                result, timestamp = cache[key]
                if current_time - timestamp < ttl_seconds:
                    return result
            
            # Call function and cache result
            result = func(*args, **kwargs)
            cache[key] = (result, current_time)
            return result
        return wrapper
    return decorator

# Usage
@retry(max_attempts=3, delay=2.0)
@cache_result(ttl_seconds=600)
def fetch_user_data(user_id: int) -> dict:
    # Expensive API call
    response = requests.get(f"/api/users/{user_id}")
    response.raise_for_status()
    return response.json()
```

### Facade Pattern
```python
class EmailService:
    def send_email(self, to: str, subject: str, body: str) -> bool:
        print(f"Sending email to {to}")
        return True

class SMSService:
    def send_sms(self, phone: str, message: str) -> bool:
        print(f"Sending SMS to {phone}")
        return True

class PushNotificationService:
    def send_push(self, device_id: str, message: str) -> bool:
        print(f"Sending push to {device_id}")
        return True

class NotificationFacade:
    """Simplified interface for all notification services."""
    
    def __init__(self):
        self._email = EmailService()
        self._sms = SMSService()
        self._push = PushNotificationService()
    
    def notify_user(
        self, 
        user: dict, 
        message: str, 
        channels: list[str] = None
    ) -> dict[str, bool]:
        """Send notification via multiple channels."""
        if channels is None:
            channels = ['email']
        
        results = {}
        
        if 'email' in channels and user.get('email'):
            results['email'] = self._email.send_email(
                user['email'], "Notification", message
            )
        
        if 'sms' in channels and user.get('phone'):
            results['sms'] = self._sms.send_sms(
                user['phone'], message
            )
        
        if 'push' in channels and user.get('device_id'):
            results['push'] = self._push.send_push(
                user['device_id'], message
            )
        
        return results
```

## Behavioral Patterns

### Observer Pattern
```python
from abc import ABC, abstractmethod
from typing import List, Any

class Observer(ABC):
    @abstractmethod
    def update(self, subject: 'Subject', event_type: str, data: Any) -> None:
        pass

class Subject:
    def __init__(self):
        self._observers: List[Observer] = []
    
    def attach(self, observer: Observer) -> None:
        self._observers.append(observer)
    
    def detach(self, observer: Observer) -> None:
        self._observers.remove(observer)
    
    def notify(self, event_type: str, data: Any = None) -> None:
        for observer in self._observers:
            observer.update(self, event_type, data)

class User(Subject):
    def __init__(self, username: str):
        super().__init__()
        self.username = username
        self._profile = {}
    
    def update_profile(self, key: str, value: Any) -> None:
        old_value = self._profile.get(key)
        self._profile[key] = value
        self.notify('profile_updated', {
            'key': key,
            'old_value': old_value,
            'new_value': value
        })

class EmailNotifier(Observer):
    def update(self, subject: Subject, event_type: str, data: Any) -> None:
        if event_type == 'profile_updated':
            print(f"Email: {subject.username} updated {data['key']}")

class AuditLogger(Observer):
    def update(self, subject: Subject, event_type: str, data: Any) -> None:
        print(f"Audit: {event_type} for {subject.username} - {data}")

# Usage
user = User("alice")
user.attach(EmailNotifier())
user.attach(AuditLogger())
user.update_profile("email", "alice@example.com")
```

### Strategy Pattern
```python
from abc import ABC, abstractmethod
from typing import List

class SortingStrategy(ABC):
    @abstractmethod
    def sort(self, data: List[int]) -> List[int]:
        pass

class BubbleSort(SortingStrategy):
    def sort(self, data: List[int]) -> List[int]:
        data = data.copy()
        n = len(data)
        for i in range(n):
            for j in range(0, n - i - 1):
                if data[j] > data[j + 1]:
                    data[j], data[j + 1] = data[j + 1], data[j]
        return data

class QuickSort(SortingStrategy):
    def sort(self, data: List[int]) -> List[int]:
        if len(data) <= 1:
            return data
        pivot = data[len(data) // 2]
        left = [x for x in data if x < pivot]
        middle = [x for x in data if x == pivot]
        right = [x for x in data if x > pivot]
        return self.sort(left) + middle + self.sort(right)

class Sorter:
    def __init__(self, strategy: SortingStrategy):
        self._strategy = strategy
    
    def set_strategy(self, strategy: SortingStrategy) -> None:
        self._strategy = strategy
    
    def sort(self, data: List[int]) -> List[int]:
        return self._strategy.sort(data)

# Usage
data = [64, 34, 25, 12, 22, 11, 90]
sorter = Sorter(QuickSort())
sorted_data = sorter.sort(data)
```

### Command Pattern
```python
from abc import ABC, abstractmethod
from typing import List, Any

class Command(ABC):
    @abstractmethod
    def execute(self) -> Any:
        pass
    
    @abstractmethod
    def undo(self) -> Any:
        pass

class CreateFileCommand(Command):
    def __init__(self, filename: str, content: str = ""):
        self.filename = filename
        self.content = content
    
    def execute(self) -> None:
        with open(self.filename, 'w') as f:
            f.write(self.content)
        print(f"Created file: {self.filename}")
    
    def undo(self) -> None:
        import os
        if os.path.exists(self.filename):
            os.remove(self.filename)
            print(f"Deleted file: {self.filename}")

class WriteToFileCommand(Command):
    def __init__(self, filename: str, content: str):
        self.filename = filename
        self.content = content
        self.original_content = ""
    
    def execute(self) -> None:
        # Save original content for undo
        try:
            with open(self.filename, 'r') as f:
                self.original_content = f.read()
        except FileNotFoundError:
            self.original_content = ""
        
        with open(self.filename, 'w') as f:
            f.write(self.content)
        print(f"Wrote to file: {self.filename}")
    
    def undo(self) -> None:
        with open(self.filename, 'w') as f:
            f.write(self.original_content)
        print(f"Restored file: {self.filename}")

class CommandInvoker:
    def __init__(self):
        self._history: List[Command] = []
    
    def execute_command(self, command: Command) -> None:
        command.execute()
        self._history.append(command)
    
    def undo_last(self) -> None:
        if self._history:
            command = self._history.pop()
            command.undo()
```

## Modern Python Patterns (2025)

### Protocol Pattern (Structural Typing)
```python
from typing import Protocol, runtime_checkable

@runtime_checkable
class Drawable(Protocol):
    def draw(self) -> None: ...
    def get_area(self) -> float: ...

class Circle:
    def __init__(self, radius: float):
        self.radius = radius
    
    def draw(self) -> None:
        print(f"Drawing circle with radius {self.radius}")
    
    def get_area(self) -> float:
        return 3.14159 * self.radius ** 2

class Rectangle:
    def __init__(self, width: float, height: float):
        self.width = width
        self.height = height
    
    def draw(self) -> None:
        print(f"Drawing rectangle {self.width}x{self.height}")
    
    def get_area(self) -> float:
        return self.width * self.height

def draw_shape(shape: Drawable) -> None:
    shape.draw()
    print(f"Area: {shape.get_area()}")

# Usage - duck typing with type safety
shapes = [Circle(5), Rectangle(3, 4)]
for shape in shapes:
    draw_shape(shape)
```

### Context Manager Pattern
```python
from contextlib import contextmanager
import tempfile
import os

@contextmanager
def temporary_file(suffix: str = ".tmp"):
    """Context manager for temporary files."""
    fd, path = tempfile.mkstemp(suffix=suffix)
    try:
        with os.fdopen(fd, 'w') as f:
            yield f, path
    finally:
        if os.path.exists(path):
            os.unlink(path)

# Usage
with temporary_file(".json") as (file, path):
    file.write('{"test": true}')
    print(f"Temporary file created at: {path}")
# File automatically deleted when context exits
```

### Async Iterator Pattern
```python
import asyncio
from typing import AsyncIterator

class AsyncDataProcessor:
    def __init__(self, data: list):
        self.data = data
    
    async def __aiter__(self) -> AsyncIterator[str]:
        for item in self.data:
            # Simulate async processing
            await asyncio.sleep(0.1)
            yield f"Processed: {item}"

# Usage
async def main():
    processor = AsyncDataProcessor([1, 2, 3, 4, 5])
    async for result in processor:
        print(result)

# Run with asyncio.run(main())
```

## Anti-Patterns to Avoid

### God Class
```python
# Bad - doing everything
class UserManager:
    def authenticate(self): pass
    def send_email(self): pass
    def log_activity(self): pass
    def process_payment(self): pass
    def generate_report(self): pass
    # ... 50 more methods

# Good - single responsibility
class UserAuthenticator: pass
class EmailService: pass
class ActivityLogger: pass
class PaymentProcessor: pass
class ReportGenerator: pass
```

### Circular Dependencies
```python
# Bad - circular import
# models.py
from services import UserService
class User:
    def save(self):
        UserService.save(self)

# services.py
from models import User
class UserService:
    @staticmethod
    def save(user: User): pass

# Good - dependency injection
class UserService:
    def save(self, user): pass  # Accept any user-like object

class User:
    def __init__(self, user_service: UserService):
        self._user_service = user_service
    
    def save(self):
        self._user_service.save(self)
```

---

**Key Takeaway**: Design patterns are tools, not rules. Use them when they solve real problems and improve code maintainability.
