module SqueelHelper
  def dsl(&block)
    Squeel::DSL.eval(&block)
  end

  def dsl_exec(*args, &block)
    Squeel::DSL.exec(*args, &block)
  end

  def queries_for
    $queries_executed = []
    yield
    $queries_executed
  ensure
    %w{ BEGIN COMMIT }.each { |x| $queries_executed.delete(x) }
  end

  def new_join_dependency(*args)
    if defined?(ActiveRecord::Associations::JoinDependency)
      ActiveRecord::Associations::JoinDependency.new(*args)
    else
      ActiveRecord::Associations::ClassMethods::JoinDependency.new(*args)
    end
  end

  def activerecord_at_least_version(version_string)
    required_version_parts = version_string.split('.', 3).map(&:to_i)
    (0..2).each do |index|
      required_version_parts[index] ||= 0
    end
    actual_version_parts = [
      ActiveRecord::VERSION::MAJOR,
      ActiveRecord::VERSION::MINOR,
      ActiveRecord::VERSION::TINY
    ]
    (actual_version_parts <=> required_version_parts) >= 0
  end
end
