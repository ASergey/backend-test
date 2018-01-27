books_titles = [
  'Do Androids Dream of Electric Sheep?',
  "I Was Told There'd Be Cake",
  'The Curious Incident of the Dog in the Night-Time',
  'To Kill a Mockingbird',
  'Cloudy With a Chance of Meatballs',
  'Where the Wild Things Are',
  'A Heartbreaking Work of Staggering Genius',
  'Alexander and the Terrible, Horrible, No Good, Very Bad Day'
]

publishers = Publisher.create([
  { name: 'Piter' },
  { name: 'Alpina' },
  { name: "O'Relly" },
  { name: 'Eksmo' },
  { name: 'The Science' }
])

books = []
books_titles.each do |title|
  books << Book.create(title: title, publisher: publishers.sample)
end

['Labirint', 'Amazon', 'Ozon', 'Atrium'].each do |shop_name|
  books_in_shop = []
  books.each do |book|
    books_in_shop << { book: book, sold_count: rand(0..10), in_stock: rand(0..50) }
  end

  Shop.create(name: shop_name, books_in_shop_attributes: books_in_shop)
end
