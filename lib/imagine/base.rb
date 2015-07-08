class Imagine
  class Base
    %i(to_h header shot_time read).each do |method|
      define_method(method) do
        fail NotImplementedError, "should be implemented method `#{method}'"
      end
    end
  end
end
