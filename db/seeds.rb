# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# IMPORTANT: Do NOT add Administrator data here!
# Administrator accounts should be created manually or through separate admin setup commands.
# This seeds file is only for application data (products, categories, etc.)

# Write your seed data here

# Create sample books
books_data = [
  {
    title: "The Art of Neo-Brutalism",
    author: "Marcus Concrete",
    price: 29.99,
    description: "Explore the raw, uncompromising world of Neo-Brutalist design. This comprehensive guide covers the history, principles, and modern applications of this bold architectural and design movement.",
    cover_image: "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=600&fit=crop",
    isbn: "978-0-123456-78-9",
    stock: 15
  },
  {
    title: "Digital Minimalism",
    author: "Cal Newport",
    price: 24.99,
    description: "A philosophy of technology use in which you focus your online time on a small number of carefully selected and optimized activities that strongly support things you value.",
    cover_image: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400&h=600&fit=crop",
    isbn: "978-0-525-53650-8",
    stock: 20
  },
  {
    title: "The Design of Everyday Things",
    author: "Don Norman",
    price: 19.99,
    description: "The ultimate guide to human-centered design. Learn how good design enhances our lives and bad design ruins them.",
    cover_image: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop",
    isbn: "978-0-465-05065-9",
    stock: 12
  },
  {
    title: "Atomic Habits",
    author: "James Clear",
    price: 26.99,
    description: "An easy & proven way to build good habits & break bad ones. Learn how tiny changes in behavior can lead to remarkable results.",
    cover_image: "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=600&fit=crop",
    isbn: "978-0-7352-1129-2",
    stock: 25
  },
  {
    title: "The Pragmatic Programmer",
    author: "David Thomas",
    price: 34.99,
    description: "Your journey to mastery. A classic guide to programming craftsmanship that has inspired generations of developers.",
    cover_image: "https://images.unsplash.com/photo-1532012197267-da84d127e765?w=400&h=600&fit=crop",
    isbn: "978-0-201-61622-4",
    stock: 18
  },
  {
    title: "Clean Code",
    author: "Robert C. Martin",
    price: 31.99,
    description: "A handbook of agile software craftsmanship. Learn the principles, patterns, and practices of writing clean code.",
    cover_image: "https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=400&h=600&fit=crop",
    isbn: "978-0-13-235088-4",
    stock: 22
  },
  {
    title: "Thinking, Fast and Slow",
    author: "Daniel Kahneman",
    price: 27.99,
    description: "A groundbreaking tour of the mind that explains the two systems that drive the way we think and make decisions.",
    cover_image: "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=600&fit=crop",
    isbn: "978-0-374-53355-7",
    stock: 16
  },
  {
    title: "The Lean Startup",
    author: "Eric Ries",
    price: 23.99,
    description: "How today's entrepreneurs use continuous innovation to create radically successful businesses.",
    cover_image: "https://images.unsplash.com/photo-1495640388908-05fa85288e61?w=400&h=600&fit=crop",
    isbn: "978-0-307-88789-4",
    stock: 14
  },
  {
    title: "Zero to One",
    author: "Peter Thiel",
    price: 25.99,
    description: "Notes on startups, or how to build the future. A contrarian guide to creating breakthrough companies.",
    cover_image: "https://images.unsplash.com/photo-1550399105-c4db5fb85c18?w=400&h=600&fit=crop",
    isbn: "978-0-804-13929-4",
    stock: 19
  },
  {
    title: "The Mom Test",
    author: "Rob Fitzpatrick",
    price: 21.99,
    description: "How to talk to customers & learn if your business is a good idea when everyone is lying to you.",
    cover_image: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop",
    isbn: "978-1-492-18019-6",
    stock: 11
  },
  {
    title: "Hooked",
    author: "Nir Eyal",
    price: 24.99,
    description: "How to build habit-forming products that engage customers and drive growth.",
    cover_image: "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=600&fit=crop",
    isbn: "978-1-59184-671-1",
    stock: 17
  },
  {
    title: "Don't Make Me Think",
    author: "Steve Krug",
    price: 22.99,
    description: "A common sense approach to web usability. The classic guide to intuitive navigation and information design.",
    cover_image: "https://images.unsplash.com/photo-1532012197267-da84d127e765?w=400&h=600&fit=crop",
    isbn: "978-0-321-96551-6",
    stock: 13
  }
]

puts "Creating books..."
books_data.each do |book_attrs|
  book = Book.find_or_create_by(isbn: book_attrs[:isbn]) do |b|
    b.title = book_attrs[:title]
    b.author = book_attrs[:author]
    b.price = book_attrs[:price]
    b.description = book_attrs[:description]
    b.cover_image = book_attrs[:cover_image]
    b.stock = book_attrs[:stock]
  end
  
  if book.persisted?
    puts "✓ Created/found book: #{book.title}"
  else
    puts "✗ Failed to create book: #{book_attrs[:title]} - #{book.errors.full_messages.join(', ')}"
  end
end

puts "Seed completed! Created #{Book.count} books."
