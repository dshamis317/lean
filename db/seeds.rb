# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

topics = ["Politics", "Entertainment", "Technology", "Finance", "Sports"]

topics.each do |topic|
  Topic.create({name: topic})
end

CSV.foreach("db/seed_data/politics.csv", :headers => true, :col_sep => ',', :encoding => 'windows-1251:utf-8') do |row|
  Feed.create({
    :topic_id => 1,
    :name => row[0],
    :url => row[1]
    })
end

CSV.foreach("db/seed_data/entertainment.csv", :headers => true, :col_sep => ',', :encoding => 'windows-1251:utf-8') do |row|
  Feed.create({
    :topic_id => 2,
    :name => row[0],
    :url => row[1]
    })
end

CSV.foreach("db/seed_data/technology.csv", :headers => true, :col_sep => ',', :encoding => 'windows-1251:utf-8') do |row|
  Feed.create({
    :topic_id => 3,
    :name => row[0],
    :url => row[1]
    })
end

CSV.foreach("db/seed_data/finance.csv", :headers => true, :col_sep => ',', :encoding => 'windows-1251:utf-8') do |row|
  Feed.create({
    :topic_id => 4,
    :name => row[0],
    :url => row[1]
    })
end

CSV.foreach("db/seed_data/sports.csv", :headers => true, :col_sep => ',', :encoding => 'windows-1251:utf-8') do |row|
  Feed.create({
    :topic_id => 5,
    :name => row[0],
    :url => row[1]
    })
end
