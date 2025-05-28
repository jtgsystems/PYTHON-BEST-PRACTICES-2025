# Data Science Pipeline - 2025 Best Practices

## Complete Data Science Project Structure

```python
# src/data_pipeline/core/data_loader.py
"""Modern data loading with type safety and validation."""

from pathlib import Path
from typing import Union, Dict, Any, Optional, List
import pandas as pd
import numpy as np
from pydantic import BaseModel, validator
import polars as pl  # Modern alternative to pandas
from dataclasses import dataclass


class DataConfig(BaseModel):
    """Configuration for data loading."""
    
    file_path: Path
    file_type: str
    encoding: str = "utf-8"
    delimiter: str = ","
    skip_rows: int = 0
    max_rows: Optional[int] = None
    columns: Optional[List[str]] = None
    
    @validator('file_type')
    def validate_file_type(cls, v):
        allowed_types = ['csv', 'json', 'parquet', 'excel']
        if v not in allowed_types:
            raise ValueError(f"File type must be one of {allowed_types}")
        return v
    
    @validator('file_path')
    def validate_file_exists(cls, v):
        if not v.exists():
            raise ValueError(f"File does not exist: {v}")
        return v


@dataclass
class DataQualityReport:
    """Data quality assessment report."""
    
    total_rows: int
    total_columns: int
    missing_values: Dict[str, int]
    duplicate_rows: int
    data_types: Dict[str, str]
    memory_usage: str
    quality_score: float


class ModernDataLoader:
    """Type-safe data loader with validation."""
    
    def __init__(self, config: DataConfig):
        self.config = config
        self._data: Optional[pd.DataFrame] = None
        self._polars_data: Optional[pl.DataFrame] = None
    
    def load_pandas(self) -> pd.DataFrame:
        """Load data using pandas with optimizations."""
        load_kwargs = {
            'encoding': self.config.encoding,
            'nrows': self.config.max_rows,
            'skiprows': self.config.skip_rows,
        }
        
        if self.config.file_type == 'csv':
            load_kwargs['sep'] = self.config.delimiter
            if self.config.columns:
                load_kwargs['usecols'] = self.config.columns
            
            # Memory optimizations
            load_kwargs['low_memory'] = False
            self._data = pd.read_csv(self.config.file_path, **load_kwargs)
            
        elif self.config.file_type == 'parquet':
            # Parquet is much faster and more efficient
            self._data = pd.read_parquet(self.config.file_path)
            
        elif self.config.file_type == 'json':
            self._data = pd.read_json(self.config.file_path)
            
        elif self.config.file_type == 'excel':
            self._data = pd.read_excel(self.config.file_path, **load_kwargs)
        
        # Optimize data types automatically
        self._optimize_dtypes()
        return self._data
    
    def load_polars(self) -> pl.DataFrame:
        """Load data using Polars (faster alternative to pandas)."""
        if self.config.file_type == 'csv':
            self._polars_data = pl.read_csv(
                self.config.file_path,
                separator=self.config.delimiter,
                encoding=self.config.encoding,
                n_rows=self.config.max_rows,
                skip_rows=self.config.skip_rows,
                columns=self.config.columns,
            )
        elif self.config.file_type == 'parquet':
            self._polars_data = pl.read_parquet(self.config.file_path)
            
        return self._polars_data
    
    def _optimize_dtypes(self) -> None:
        """Optimize pandas data types for memory efficiency."""
        if self._data is None:
            return
        
        # Optimize integer columns
        for col in self._data.select_dtypes(include=['int64']).columns:
            col_min = self._data[col].min()
            col_max = self._data[col].max()
            
            if col_min >= 0:  # Unsigned integers
                if col_max < np.iinfo(np.uint8).max:
                    self._data[col] = self._data[col].astype(np.uint8)
                elif col_max < np.iinfo(np.uint16).max:
                    self._data[col] = self._data[col].astype(np.uint16)
                elif col_max < np.iinfo(np.uint32).max:
                    self._data[col] = self._data[col].astype(np.uint32)
            else:  # Signed integers
                if col_min > np.iinfo(np.int8).min and col_max < np.iinfo(np.int8).max:
                    self._data[col] = self._data[col].astype(np.int8)
                elif col_min > np.iinfo(np.int16).min and col_max < np.iinfo(np.int16).max:
                    self._data[col] = self._data[col].astype(np.int16)
                elif col_min > np.iinfo(np.int32).min and col_max < np.iinfo(np.int32).max:
                    self._data[col] = self._data[col].astype(np.int32)
        
        # Optimize float columns
        for col in self._data.select_dtypes(include=['float64']).columns:
            self._data[col] = pd.to_numeric(self._data[col], downcast='float')
        
        # Convert to categorical for string columns with low cardinality
        for col in self._data.select_dtypes(include=['object']).columns:
            if self._data[col].nunique() / len(self._data) < 0.5:  # Less than 50% unique
                self._data[col] = self._data[col].astype('category')
    
    def generate_quality_report(self) -> DataQualityReport:
        """Generate comprehensive data quality report."""
        if self._data is None:
            raise ValueError("Data not loaded. Call load_pandas() first.")
        
        missing_values = self._data.isnull().sum().to_dict()
        duplicate_rows = self._data.duplicated().sum()
        data_types = self._data.dtypes.astype(str).to_dict()
        memory_usage = f"{self._data.memory_usage(deep=True).sum() / 1024**2:.2f} MB"
        
        # Calculate quality score
        missing_ratio = sum(missing_values.values()) / (len(self._data) * len(self._data.columns))
        duplicate_ratio = duplicate_rows / len(self._data)
        quality_score = 1.0 - (missing_ratio * 0.5 + duplicate_ratio * 0.5)
        
        return DataQualityReport(
            total_rows=len(self._data),
            total_columns=len(self._data.columns),
            missing_values=missing_values,
            duplicate_rows=duplicate_rows,
            data_types=data_types,
            memory_usage=memory_usage,
            quality_score=quality_score
        )


# src/data_pipeline/processing/feature_engineering.py
"""Advanced feature engineering with type safety."""

from typing import List, Dict, Any, Optional, Callable, Union
import pandas as pd
import numpy as np
from sklearn.base import BaseEstimator, TransformerMixin
from sklearn.preprocessing import StandardScaler, LabelEncoder, OneHotEncoder
from sklearn.impute import SimpleImputer, KNNImputer
import warnings


class TypeSafeFeatureTransformer(BaseEstimator, TransformerMixin):
    """Base class for type-safe feature transformers."""
    
    def __init__(self):
        self.feature_names_: Optional[List[str]] = None
        self.is_fitted_: bool = False
    
    def _validate_input(self, X: pd.DataFrame) -> pd.DataFrame:
        """Validate input data."""
        if not isinstance(X, pd.DataFrame):
            raise TypeError("Input must be a pandas DataFrame")
        
        if self.is_fitted_ and self.feature_names_ is not None:
            missing_features = set(self.feature_names_) - set(X.columns)
            if missing_features:
                raise ValueError(f"Missing features: {missing_features}")
        
        return X
    
    def fit(self, X: pd.DataFrame, y: Optional[pd.Series] = None):
        """Fit the transformer."""
        X = self._validate_input(X)
        self.feature_names_ = list(X.columns)
        self.is_fitted_ = True
        return self
    
    def transform(self, X: pd.DataFrame) -> pd.DataFrame:
        """Transform the data."""
        if not self.is_fitted_:
            raise ValueError("Transformer not fitted. Call fit() first.")
        
        X = self._validate_input(X)
        return self._transform_impl(X)
    
    def _transform_impl(self, X: pd.DataFrame) -> pd.DataFrame:
        """Implementation of transform method."""
        raise NotImplementedError


class SmartMissingValueImputer(TypeSafeFeatureTransformer):
    """Intelligent missing value imputation."""
    
    def __init__(self, strategy: str = 'auto', n_neighbors: int = 5):
        super().__init__()
        self.strategy = strategy
        self.n_neighbors = n_neighbors
        self.imputers_: Dict[str, Any] = {}
        self.strategies_: Dict[str, str] = {}
    
    def fit(self, X: pd.DataFrame, y: Optional[pd.Series] = None):
        """Fit imputers for each column."""
        super().fit(X, y)
        
        for column in X.columns:
            missing_ratio = X[column].isnull().mean()
            
            if missing_ratio == 0:
                continue  # No missing values
            
            # Determine strategy based on data type and missing ratio
            if self.strategy == 'auto':
                if X[column].dtype in ['object', 'category']:
                    strategy = 'most_frequent'
                elif missing_ratio < 0.1:  # Less than 10% missing
                    strategy = 'mean' if X[column].dtype in ['float64', 'int64'] else 'most_frequent'
                else:  # High missing ratio - use KNN
                    strategy = 'knn'
            else:
                strategy = self.strategy
            
            self.strategies_[column] = strategy
            
            if strategy == 'knn':
                # Use only numeric columns for KNN
                numeric_columns = X.select_dtypes(include=[np.number]).columns
                self.imputers_[column] = KNNImputer(n_neighbors=self.n_neighbors)
                self.imputers_[column].fit(X[numeric_columns])
            else:
                self.imputers_[column] = SimpleImputer(strategy=strategy)
                self.imputers_[column].fit(X[[column]])
        
        return self
    
    def _transform_impl(self, X: pd.DataFrame) -> pd.DataFrame:
        """Apply imputation transformations."""
        X_transformed = X.copy()
        
        for column, imputer in self.imputers_.items():
            if column not in X_transformed.columns:
                continue
            
            if self.strategies_[column] == 'knn':
                numeric_columns = X_transformed.select_dtypes(include=[np.number]).columns
                X_transformed[numeric_columns] = imputer.transform(X_transformed[numeric_columns])
            else:
                X_transformed[[column]] = imputer.transform(X_transformed[[column]])
        
        return X_transformed


class AdvancedFeatureEngineer(TypeSafeFeatureTransformer):
    """Advanced feature engineering operations."""
    
    def __init__(self, 
                 create_interactions: bool = True,
                 create_polynomials: bool = True,
                 polynomial_degree: int = 2,
                 create_date_features: bool = True):
        super().__init__()
        self.create_interactions = create_interactions
        self.create_polynomials = create_polynomials
        self.polynomial_degree = polynomial_degree
        self.create_date_features = create_date_features
        self.numeric_columns_: List[str] = []
        self.date_columns_: List[str] = []
    
    def fit(self, X: pd.DataFrame, y: Optional[pd.Series] = None):
        """Identify column types for feature engineering."""
        super().fit(X, y)
        
        self.numeric_columns_ = list(X.select_dtypes(include=[np.number]).columns)
        self.date_columns_ = list(X.select_dtypes(include=['datetime64']).columns)
        
        # Try to detect date columns that might be strings
        for col in X.select_dtypes(include=['object']).columns:
            try:
                pd.to_datetime(X[col].dropna().head(100))
                self.date_columns_.append(col)
            except:
                pass
        
        return self
    
    def _transform_impl(self, X: pd.DataFrame) -> pd.DataFrame:
        """Create engineered features."""
        X_transformed = X.copy()
        
        # Create date features
        if self.create_date_features:
            X_transformed = self._create_date_features(X_transformed)
        
        # Create polynomial features
        if self.create_polynomials and len(self.numeric_columns_) > 0:
            X_transformed = self._create_polynomial_features(X_transformed)
        
        # Create interaction features
        if self.create_interactions and len(self.numeric_columns_) > 1:
            X_transformed = self._create_interaction_features(X_transformed)
        
        return X_transformed
    
    def _create_date_features(self, X: pd.DataFrame) -> pd.DataFrame:
        """Create features from date columns."""
        for col in self.date_columns_:
            if col not in X.columns:
                continue
            
            # Convert to datetime if needed
            if X[col].dtype == 'object':
                X[col] = pd.to_datetime(X[col], errors='coerce')
            
            # Extract date components
            X[f'{col}_year'] = X[col].dt.year
            X[f'{col}_month'] = X[col].dt.month
            X[f'{col}_day'] = X[col].dt.day
            X[f'{col}_dayofweek'] = X[col].dt.dayofweek
            X[f'{col}_quarter'] = X[col].dt.quarter
            X[f'{col}_is_weekend'] = X[col].dt.dayofweek.isin([5, 6]).astype(int)
            
            # Create cyclical features for temporal patterns
            X[f'{col}_month_sin'] = np.sin(2 * np.pi * X[f'{col}_month'] / 12)
            X[f'{col}_month_cos'] = np.cos(2 * np.pi * X[f'{col}_month'] / 12)
            X[f'{col}_day_sin'] = np.sin(2 * np.pi * X[f'{col}_day'] / 31)
            X[f'{col}_day_cos'] = np.cos(2 * np.pi * X[f'{col}_day'] / 31)
        
        return X
    
    def _create_polynomial_features(self, X: pd.DataFrame) -> pd.DataFrame:
        """Create polynomial features for numeric columns."""
        for col in self.numeric_columns_[:5]:  # Limit to avoid explosion
            if col not in X.columns:
                continue
            
            for degree in range(2, self.polynomial_degree + 1):
                X[f'{col}_pow_{degree}'] = X[col] ** degree
        
        return X
    
    def _create_interaction_features(self, X: pd.DataFrame) -> pd.DataFrame:
        """Create interaction features between numeric columns."""
        from itertools import combinations
        
        # Limit combinations to avoid feature explosion
        columns_to_combine = self.numeric_columns_[:10]
        
        for col1, col2 in combinations(columns_to_combine, 2):
            if col1 not in X.columns or col2 not in X.columns:
                continue
            
            # Multiplicative interaction
            X[f'{col1}_x_{col2}'] = X[col1] * X[col2]
            
            # Ratio features (avoid division by zero)
            with warnings.catch_warnings():
                warnings.simplefilter("ignore")
                X[f'{col1}_div_{col2}'] = X[col1] / (X[col2] + 1e-8)
        
        return X


# src/data_pipeline/models/model_trainer.py
"""Modern model training with MLOps practices."""

from typing import Dict, Any, List, Optional, Tuple
import pandas as pd
import numpy as np
from sklearn.model_selection import cross_val_score, RandomizedSearchCV
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix
import joblib
from pathlib import Path
import mlflow
import mlflow.sklearn
from dataclasses import dataclass, asdict
import json


@dataclass
class ModelConfig:
    """Configuration for model training."""
    
    model_type: str
    hyperparameters: Dict[str, Any]
    cross_validation_folds: int = 5
    random_state: int = 42
    test_size: float = 0.2
    
    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary."""
        return asdict(self)


@dataclass
class ModelMetrics:
    """Model performance metrics."""
    
    accuracy: float
    precision: float
    recall: float
    f1_score: float
    cv_scores: List[float]
    cv_mean: float
    cv_std: float
    
    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary."""
        return asdict(self)


class MLOpsModelTrainer:
    """Model trainer with MLOps integration."""
    
    def __init__(self, experiment_name: str = "default"):
        self.experiment_name = experiment_name
        self.models = {
            'random_forest': RandomForestClassifier,
            'gradient_boosting': GradientBoostingClassifier,
            'logistic_regression': LogisticRegression
        }
        
        # Setup MLflow
        mlflow.set_experiment(experiment_name)
    
    def train_model(self, 
                   X_train: pd.DataFrame, 
                   y_train: pd.Series,
                   X_test: pd.DataFrame,
                   y_test: pd.Series,
                   config: ModelConfig) -> Tuple[Any, ModelMetrics]:
        """Train model with MLflow tracking."""
        
        with mlflow.start_run() as run:
            # Log parameters
            mlflow.log_params(config.to_dict())
            
            # Initialize model
            model_class = self.models[config.model_type]
            model = model_class(
                random_state=config.random_state,
                **config.hyperparameters
            )
            
            # Train model
            model.fit(X_train, y_train)
            
            # Evaluate model
            metrics = self._evaluate_model(model, X_train, y_train, X_test, y_test, config)
            
            # Log metrics
            mlflow.log_metrics(metrics.to_dict())
            
            # Log model
            mlflow.sklearn.log_model(model, "model")
            
            # Log feature importance if available
            if hasattr(model, 'feature_importances_'):
                feature_importance = pd.DataFrame({
                    'feature': X_train.columns,
                    'importance': model.feature_importances_
                }).sort_values('importance', ascending=False)
                
                feature_importance.to_csv('feature_importance.csv', index=False)
                mlflow.log_artifact('feature_importance.csv')
            
            return model, metrics
    
    def _evaluate_model(self, 
                       model: Any,
                       X_train: pd.DataFrame,
                       y_train: pd.Series,
                       X_test: pd.DataFrame,
                       y_test: pd.Series,
                       config: ModelConfig) -> ModelMetrics:
        """Comprehensive model evaluation."""
        
        # Cross-validation on training data
        cv_scores = cross_val_score(
            model, X_train, y_train, 
            cv=config.cross_validation_folds,
            scoring='accuracy'
        )
        
        # Test set evaluation
        y_pred = model.predict(X_test)
        
        from sklearn.metrics import accuracy_score, precision_recall_fscore_support
        
        accuracy = accuracy_score(y_test, y_pred)
        precision, recall, f1, _ = precision_recall_fscore_support(
            y_test, y_pred, average='weighted'
        )
        
        return ModelMetrics(
            accuracy=accuracy,
            precision=precision,
            recall=recall,
            f1_score=f1,
            cv_scores=cv_scores.tolist(),
            cv_mean=cv_scores.mean(),
            cv_std=cv_scores.std()
        )
    
    def hyperparameter_search(self,
                            X_train: pd.DataFrame,
                            y_train: pd.Series,
                            model_type: str,
                            param_distributions: Dict[str, Any],
                            n_iter: int = 50) -> Dict[str, Any]:
        """Perform hyperparameter search."""
        
        model_class = self.models[model_type]
        model = model_class(random_state=42)
        
        search = RandomizedSearchCV(
            model,
            param_distributions=param_distributions,
            n_iter=n_iter,
            cv=5,
            scoring='accuracy',
            n_jobs=-1,
            random_state=42
        )
        
        search.fit(X_train, y_train)
        
        return search.best_params_
    
    def save_model(self, model: Any, model_path: Path) -> None:
        """Save model to disk."""
        joblib.dump(model, model_path)
    
    def load_model(self, model_path: Path) -> Any:
        """Load model from disk."""
        return joblib.load(model_path)


# Example usage and pipeline
class DataSciencePipeline:
    """Complete data science pipeline."""
    
    def __init__(self, config_path: Optional[Path] = None):
        self.config = self._load_config(config_path) if config_path else {}
        self.data_loader: Optional[ModernDataLoader] = None
        self.feature_engineer: Optional[AdvancedFeatureEngineer] = None
        self.imputer: Optional[SmartMissingValueImputer] = None
        self.trainer: Optional[MLOpsModelTrainer] = None
    
    def _load_config(self, config_path: Path) -> Dict[str, Any]:
        """Load configuration from file."""
        with open(config_path, 'r') as f:
            return json.load(f)
    
    def load_data(self, file_path: Path, file_type: str = 'csv') -> pd.DataFrame:
        """Load data with validation."""
        data_config = DataConfig(
            file_path=file_path,
            file_type=file_type
        )
        
        self.data_loader = ModernDataLoader(data_config)
        data = self.data_loader.load_pandas()
        
        # Generate quality report
        quality_report = self.data_loader.generate_quality_report()
        print(f"Data Quality Score: {quality_report.quality_score:.2f}")
        print(f"Missing Values: {sum(quality_report.missing_values.values())}")
        
        return data
    
    def preprocess_data(self, data: pd.DataFrame) -> pd.DataFrame:
        """Preprocess data with feature engineering."""
        # Handle missing values
        self.imputer = SmartMissingValueImputer(strategy='auto')
        data = self.imputer.fit_transform(data)
        
        # Feature engineering
        self.feature_engineer = AdvancedFeatureEngineer(
            create_interactions=True,
            create_polynomials=True,
            polynomial_degree=2
        )
        data = self.feature_engineer.fit_transform(data)
        
        return data
    
    def train_models(self, 
                    X: pd.DataFrame, 
                    y: pd.Series,
                    models_to_train: List[str] = None) -> Dict[str, Tuple[Any, ModelMetrics]]:
        """Train multiple models and compare performance."""
        
        if models_to_train is None:
            models_to_train = ['random_forest', 'gradient_boosting', 'logistic_regression']
        
        from sklearn.model_selection import train_test_split
        
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42, stratify=y
        )
        
        self.trainer = MLOpsModelTrainer(experiment_name="data_science_pipeline")
        
        results = {}
        
        for model_type in models_to_train:
            print(f"Training {model_type}...")
            
            # Default configurations for each model
            configs = {
                'random_forest': ModelConfig(
                    model_type=model_type,
                    hyperparameters={'n_estimators': 100, 'max_depth': 10}
                ),
                'gradient_boosting': ModelConfig(
                    model_type=model_type,
                    hyperparameters={'n_estimators': 100, 'learning_rate': 0.1}
                ),
                'logistic_regression': ModelConfig(
                    model_type=model_type,
                    hyperparameters={'max_iter': 1000}
                )
            }
            
            config = configs[model_type]
            model, metrics = self.trainer.train_model(
                X_train, y_train, X_test, y_test, config
            )
            
            results[model_type] = (model, metrics)
            print(f"Accuracy: {metrics.accuracy:.3f} ± {metrics.cv_std:.3f}")
        
        return results
    
    def run_complete_pipeline(self, 
                            data_path: Path, 
                            target_column: str) -> Dict[str, Tuple[Any, ModelMetrics]]:
        """Run the complete data science pipeline."""
        
        print("Loading data...")
        data = self.load_data(data_path)
        
        print("Preprocessing data...")
        # Separate features and target
        X = data.drop(columns=[target_column])
        y = data[target_column]
        
        X_processed = self.preprocess_data(X)
        
        print("Training models...")
        results = self.train_models(X_processed, y)
        
        # Print comparison
        print("\nModel Comparison:")
        print("-" * 50)
        for model_name, (model, metrics) in results.items():
            print(f"{model_name:20} Accuracy: {metrics.accuracy:.3f} ± {metrics.cv_std:.3f}")
        
        return results


# Example usage
if __name__ == "__main__":
    # Example pipeline usage
    pipeline = DataSciencePipeline()
    
    # Sample data creation for demonstration
    from sklearn.datasets import make_classification
    
    X, y = make_classification(
        n_samples=1000,
        n_features=20,
        n_informative=15,
        n_redundant=5,
        random_state=42
    )
    
    # Convert to DataFrame
    feature_names = [f'feature_{i}' for i in range(X.shape[1])]
    df = pd.DataFrame(X, columns=feature_names)
    df['target'] = y
    
    # Save sample data
    df.to_csv('sample_data.csv', index=False)
    
    # Run pipeline
    results = pipeline.run_complete_pipeline(
        data_path=Path('sample_data.csv'),
        target_column='target'
    )
