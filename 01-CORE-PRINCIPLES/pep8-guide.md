# PEP 8 Style Guide - 2025 Edition

## The Zen of Python (PEP 20)

```python
import this
```

**Key principles to internalize:**
- Beautiful is better than ugly
- Explicit is better than implicit
- Simple is better than complex
- Readability counts
- There should be one obvious way to do it

## Naming Conventions

### Variables and Functions
```python
# Good - snake_case
user_name = "alice"
def calculate_total_price():
    pass

# Bad - camelCase (not Python style)
userName = "alice"
def calculateTotalPrice():
    pass
```

### Constants
```python
# Good - SCREAMING_SNAKE_CASE
MAX_CONNECTIONS = 100
API_BASE_URL = "https://api.example.com"
DATABASE_TIMEOUT = 30
```

### Classes
```python
# Good - PascalCase
class UserManager:
    pass

class DatabaseConnection:
    pass

# Bad
class user_manager:  # Wrong case
    pass
```

### Private Variables/Methods
```python
class MyClass:
    def __init__(self):
        self.public_var = "visible"
        self._protected_var = "convention only"
        self.__private_var = "name mangled"
    
    def public_method(self):
        pass
    
    def _protected_method(self):
        pass
    
    def __private_method(self):
        pass
```

## Code Layout

### Line Length
```python
# Preferred: 88 characters (Black default)
# Absolute maximum: 100 characters for complex expressions

# Good
result = some_function(
    argument1, argument2, argument3,
    argument4, argument5
)

# Good - align with opening delimiter
result = some_function(argument1, argument2,
                      argument3, argument4)

# Good - hanging indent
result = some_function(
    argument1, argument2, argument3,
    argument4, argument5,
)
```

### Imports
```python
# Standard library imports first
import os
import sys
from pathlib import Path

# Related third party imports second
import requests
import pandas as pd
from flask import Flask, request

# Local application/library specific imports last
from myapp.models import User
from myapp.utils import helper_function

# Avoid wildcard imports
# Bad
from mymodule import *

# Good
from mymodule import specific_function, AnotherClass
```

### Blank Lines
```python
# Two blank lines around top-level functions and classes
import os


def top_level_function():
    pass


class TopLevelClass:
    """Top-level class with proper spacing."""
    
    def method_one(self):
        """One blank line between methods."""
        pass
    
    def method_two(self):
        pass


def another_top_level_function():
    pass
```

## Whitespace Rules

### In Expressions
```python
# Good
spam(ham[1], {eggs: 2})
foo = (0,)
if x == 4:
    print(x, y)
    x, y = y, x

# Bad
spam( ham[ 1 ], { eggs: 2 } )
foo = (0, )
if x == 4 :
    print(x , y)
    x , y = y , x
```

### Around Operators
```python
# Good
i = i + 1
submitted += 1
x = x*2 - 1
hypot2 = x*x + y*y
c = (a+b) * (a-b)

# Bad
i=i+1
submitted +=1
x = x * 2 - 1
hypot2 = x * x + y * y
c = (a + b) * (a - b)
```

## Comments and Docstrings

### Inline Comments
```python
# Good - sparingly and meaningfully
x = x + 1  # Compensate for border

# Bad - obvious or outdated
x = x + 1  # Increment x
```

### Function Docstrings
```python
def calculate_bmi(weight: float, height: float) -> float:
    """Calculate Body Mass Index.
    
    Args:
        weight: Weight in kilograms
        height: Height in meters
        
    Returns:
        BMI value as float
        
    Raises:
        ValueError: If weight or height is negative
        
    Example:
        >>> calculate_bmi(70, 1.75)
        22.857142857142858
    """
    if weight < 0 or height <= 0:
        raise ValueError("Weight and height must be positive")
    return weight / (height ** 2)
```

### Class Docstrings
```python
class UserAccount:
    """Represents a user account in the system.
    
    This class handles user authentication, profile management,
    and account-related operations.
    
    Attributes:
        username: The user's unique identifier
        email: The user's email address
        created_at: When the account was created
        
    Example:
        >>> user = UserAccount("alice", "alice@example.com")
        >>> user.is_active
        True
    """
    
    def __init__(self, username: str, email: str):
        self.username = username
        self.email = email
        self.created_at = datetime.now()
        self.is_active = True
```

## Error Handling

### Exception Handling
```python
# Good - specific exceptions
try:
    value = int(user_input)
except ValueError as e:
    logger.error(f"Invalid integer input: {e}")
    return None
except KeyboardInterrupt:
    logger.info("Operation cancelled by user")
    return None

# Bad - bare except
try:
    value = int(user_input)
except:  # Catches everything, even system exits
    return None

# Good - exception chaining
try:
    result = process_data(data)
except DataProcessingError as e:
    raise UserError("Failed to process user data") from e
```

### Custom Exceptions
```python
class ValidationError(Exception):
    """Raised when data validation fails."""
    pass

class DatabaseError(Exception):
    """Raised when database operations fail."""
    
    def __init__(self, message: str, error_code: int = None):
        super().__init__(message)
        self.error_code = error_code
```

## Function and Class Design

### Function Length and Complexity
```python
# Good - single responsibility
def validate_email(email: str) -> bool:
    """Validate email format using regex."""
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return bool(re.match(pattern, email))

def create_user(username: str, email: str) -> User:
    """Create a new user after validation."""
    if not username:
        raise ValueError("Username cannot be empty")
    if not validate_email(email):
        raise ValueError("Invalid email format")
    return User(username=username, email=email)

# Bad - doing too much
def create_user_and_setup_everything(username, email, preferences, settings):
    # 50+ lines of mixed responsibilities
    pass
```

### Use Type Hints (PEP 484, 585, 604)
```python
from typing import Dict, List, Optional, Union
from collections.abc import Sequence

# Python 3.9+ simplified syntax
def process_items(items: list[str]) -> dict[str, int]:
    """Process list of strings, return count mapping."""
    return {item: len(item) for item in items}

# Union types (Python 3.10+)
def handle_id(user_id: int | str) -> User:
    """Handle both integer and string IDs."""
    if isinstance(user_id, str):
        user_id = int(user_id)
    return get_user_by_id(user_id)

# Generic types
from typing import TypeVar, Generic

T = TypeVar('T')

class Stack(Generic[T]):
    def __init__(self) -> None:
        self._items: list[T] = []
    
    def push(self, item: T) -> None:
        self._items.append(item)
    
    def pop(self) -> T:
        return self._items.pop()
```

## Modern Python Features (2025)

### Context Managers
```python
# Good - automatic resource management
with open('file.txt', 'r') as f:
    content = f.read()

# Custom context manager
from contextlib import contextmanager

@contextmanager
def database_transaction():
    """Context manager for database transactions."""
    conn = get_connection()
    trans = conn.begin()
    try:
        yield conn
        trans.commit()
    except Exception:
        trans.rollback()
        raise
    finally:
        conn.close()

# Usage
with database_transaction() as conn:
    conn.execute("INSERT INTO users ...")
```

### Dataclasses (Python 3.7+)
```python
from dataclasses import dataclass, field
from typing import List

@dataclass
class User:
    """User data class with automatic methods."""
    username: str
    email: str
    age: int = 0
    tags: List[str] = field(default_factory=list)
    is_active: bool = True
    
    def __post_init__(self):
        """Validate data after initialization."""
        if '@' not in self.email:
            raise ValueError("Invalid email")

# Usage
user = User("alice", "alice@example.com", 25)
print(user)  # Automatic __repr__
user2 = User("bob", "bob@example.com")
assert user != user2  # Automatic __eq__
```

### Pattern Matching (Python 3.10+)
```python
def handle_response(response: dict) -> str:
    """Handle API response using pattern matching."""
    match response:
        case {"status": "success", "data": data}:
            return f"Success: {data}"
        case {"status": "error", "message": msg}:
            return f"Error: {msg}"
        case {"status": "pending"}:
            return "Request is pending"
        case _:
            return "Unknown response format"

# Class pattern matching
match user:
    case User(username="admin"):
        return "Admin access"
    case User(age=age) if age < 18:
        return "Minor user"
    case User():
        return "Regular user"
```

## Anti-Patterns to Avoid

### Mutable Default Arguments
```python
# Bad - dangerous mutable default
def add_item(item, items=[]):
    items.append(item)
    return items

# Good - use None and create new list
def add_item(item, items=None):
    if items is None:
        items = []
    items.append(item)
    return items
```

### Global Variables
```python
# Bad - global state
user_count = 0

def add_user():
    global user_count
    user_count += 1

# Good - encapsulation
class UserManager:
    def __init__(self):
        self._user_count = 0
    
    def add_user(self):
        self._user_count += 1
    
    @property
    def user_count(self):
        return self._user_count
```

### Deep Nesting
```python
# Bad - hard to read
def process_data(data):
    if data:
        if data.get('users'):
            for user in data['users']:
                if user.get('active'):
                    if user.get('email'):
                        # deep nesting continues...
                        pass

# Good - early returns and guard clauses
def process_data(data):
    if not data:
        return
    
    users = data.get('users')
    if not users:
        return
    
    for user in users:
        if not user.get('active'):
            continue
        
        email = user.get('email')
        if not email:
            continue
        
        # Process user
        process_user(user)
```

---

**Key Takeaway**: Code is read more often than written. Prioritize clarity and consistency over cleverness.
