class StocksGrid

  include Datagrid

  scope do
    Stock
  end

  filter(:id, :integer)
  filter(:created_at, :date, :range => true)

  column(:id)
  column(:name)
  column(:created_at) do |model|
    model.created_at.to_date
  end
end
