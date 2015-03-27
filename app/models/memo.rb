class Memo
  include Publishable

  def kind
    raise NotImplementedError.new
  end

  def data
    raise NotImplementedError.new
  end

end
