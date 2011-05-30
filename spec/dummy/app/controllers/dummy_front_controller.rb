class DummyFrontController < FrontController
  def list_goods
    @goods = Good.all
  end
end