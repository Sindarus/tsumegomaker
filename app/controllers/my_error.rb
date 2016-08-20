class MyError
  class Error < RuntimeError
  end

  class IaError < Error
  end

  class IaInitError < IaError
  end

  class ColorError < IaError
  end

  class MoveError < IaError
  end
end
