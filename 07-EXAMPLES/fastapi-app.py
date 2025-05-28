    ):
        """Test user creation with various validation scenarios."""
        user_service = UserService(db_session)
        
        if should_succeed:
            user = user_service.create(
                email=email,
                username=username,
                password=password
            )
            assert user.email == email
            assert user.username == username
        else:
            with pytest.raises((HTTPException, ValueError)):
                user_service.create(
                    email=email,
                    username=username,
                    password=password
                )


class TestAPIEndpoints:
    """Test API endpoints."""
    
    def test_health_check(self, client):
        """Test health check endpoint."""
        response = client.get("/health")
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "healthy"
        assert "version" in data
    
    def test_login_success(self, client, sample_user):
        """Test successful login."""
        response = client.post(
            "/api/v1/auth/login",
            json={
                "email": "test@example.com",
                "password": "testpassword123"
            }
        )
        
        assert response.status_code == 200
        data = response.json()
        assert "access_token" in data
        assert data["token_type"] == "bearer"
    
    def test_login_invalid_credentials(self, client, sample_user):
        """Test login with invalid credentials."""
        response = client.post(
            "/api/v1/auth/login",
            json={
                "email": "test@example.com",
                "password": "wrongpassword"
            }
        )
        
        assert response.status_code == 401
        assert "Incorrect email or password" in response.json()["detail"]
    
    def test_get_current_user(self, client, auth_headers):
        """Test getting current user."""
        response = client.get("/api/v1/users/me", headers=auth_headers)
        
        assert response.status_code == 200
        data = response.json()
        assert data["email"] == "test@example.com"
        assert data["username"] == "testuser"
    
    def test_unauthorized_access(self, client):
        """Test unauthorized access to protected endpoint."""
        response = client.get("/api/v1/users/me")
        
        assert response.status_code == 401
    
    def test_update_current_user(self, client, auth_headers):
        """Test updating current user."""
        response = client.put(
            "/api/v1/users/me",
            headers=auth_headers,
            json={
                "full_name": "Updated Name",
                "bio": "Updated bio"
            }
        )
        
        assert response.status_code == 200
        data = response.json()
        assert data["full_name"] == "Updated Name"
        assert data["bio"] == "Updated bio"


class TestAsyncOperations:
    """Test async operations."""
    
    @pytest.mark.asyncio
    async def test_async_endpoint(self, async_client, sample_user):
        """Test async endpoint."""
        response = await async_client.get("/health")
        assert response.status_code == 200
    
    @pytest.mark.asyncio
    async def test_async_data_processor(self):
        """Test async data processor."""
        from examples.async_pipeline import AsyncDataProcessor
        
        with patch('aiohttp.ClientSession.get') as mock_get:
            # Mock the async context manager
            mock_response = AsyncMock()
            mock_response.json.return_value = {"test": "data"}
            mock_response.raise_for_status.return_value = None
            mock_get.return_value.__aenter__.return_value = mock_response
            
            async with AsyncDataProcessor(max_concurrent=2) as processor:
                result = await processor.process_item("test1", "http://example.com")
                
                assert result.id == "test1"
                assert result.data["processed"] is True
    
    @pytest.mark.asyncio
    async def test_concurrent_processing(self):
        """Test concurrent processing performance."""
        start_time = asyncio.get_event_loop().time()
        
        async def mock_task(delay: float):
            await asyncio.sleep(delay)
            return delay
        
        # Process 5 tasks concurrently (should take ~0.1s, not 0.5s)
        tasks = [mock_task(0.1) for _ in range(5)]
        results = await asyncio.gather(*tasks)
        
        end_time = asyncio.get_event_loop().time()
        execution_time = end_time - start_time
        
        assert len(results) == 5
        assert execution_time < 0.2  # Should be much faster than sequential


class TestMockingExamples:
    """Examples of mocking external dependencies."""
    
    @patch('requests.get')
    def test_external_api_call(self, mock_get):
        """Test mocking external API calls."""
        # Setup mock
        mock_response = Mock()
        mock_response.json.return_value = {"status": "success"}
        mock_response.status_code = 200
        mock_get.return_value = mock_response
        
        # Test code that uses requests.get
        import requests
        response = requests.get("https://api.example.com/data")
        data = response.json()
        
        assert data["status"] == "success"
        mock_get.assert_called_once_with("https://api.example.com/data")
    
    @patch('app.services.user_service.get_password_hash')
    def test_mocked_password_hashing(self, mock_hash, db_session):
        """Test with mocked password hashing."""
        mock_hash.return_value = "mocked_hash"
        
        user_service = UserService(db_session)
        user = user_service.create(
            email="mock@example.com",
            username="mockuser",
            password="password123"
        )
        
        assert user.hashed_password == "mocked_hash"
        mock_hash.assert_called_once_with("password123")


class TestPerformanceAndBenchmarks:
    """Performance testing examples."""
    
    def test_user_creation_performance(self, db_session, benchmark):
        """Benchmark user creation performance."""
        user_service = UserService(db_session)
        
        def create_user():
            return user_service.create(
                email=f"bench{benchmark.iterations}@example.com",
                username=f"benchuser{benchmark.iterations}",
                password="password123"
            )
        
        result = benchmark(create_user)
        assert result.email.startswith("bench")
    
    def test_bulk_user_operations(self, db_session):
        """Test bulk operations performance."""
        user_service = UserService(db_session)
        
        # Create multiple users
        users = []
        for i in range(100):
            user = user_service.create(
                email=f"bulk{i}@example.com",
                username=f"bulkuser{i}",
                password="password123"
            )
            users.append(user)
        
        # Test bulk retrieval
        retrieved_users = user_service.get_multi(skip=0, limit=100)
        assert len(retrieved_users) >= 100


@pytest.fixture(scope="session")
def event_loop():
    """Create event loop for async tests."""
    loop = asyncio.new_event_loop()
    yield loop
    loop.close()


# Conftest.py additions for advanced testing
@pytest.fixture(autouse=True)
def clear_cache():
    """Clear any caches between tests."""
    # Clear function caches if using @lru_cache
    from app.core.config import get_settings
    get_settings.cache_clear()


@pytest.fixture
def mock_redis():
    """Mock Redis for testing."""
    with patch('redis.Redis') as mock_redis_class:
        mock_redis_instance = Mock()
        mock_redis_class.return_value = mock_redis_instance
        yield mock_redis_instance


@pytest.fixture
def mock_external_api():
    """Mock external API responses."""
    with patch('aiohttp.ClientSession') as mock_session:
        mock_response = AsyncMock()
        mock_response.json.return_value = {"mocked": True}
        mock_response.status = 200
        mock_session.return_value.__aenter__.return_value.get.return_value.__aenter__.return_value = mock_response
        yield mock_session
