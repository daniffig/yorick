# Configure Chewy default strategy for index updates (skip in test environment)
unless Rails.env.test?
  Chewy.strategy(:atomic)
end 