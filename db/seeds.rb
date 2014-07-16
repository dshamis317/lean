# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

topics = ["Politics", "Entertainment", "Technology", "Finance", "Sports"]

topics.each do |topic|
  Topic.find_or_create_by(name: topic)
end

CSV.foreach("db/seed_data/politics.csv", :headers => true, :col_sep => ',', :encoding => 'windows-1251:utf-8') do |row|
  politics = Topic.find_by(name: 'Politics')
  Feed.create({
    :topic_id => politics.id,
    :name => row[0],
    :url => row[1]
    })
end

CSV.foreach("db/seed_data/entertainment.csv", :headers => true, :col_sep => ',', :encoding => 'windows-1251:utf-8') do |row|
  entertainment = Topic.find_by(name: 'Entertainment')
  Feed.create({
    :topic_id => entertainment.id,
    :name => row[0],
    :url => row[1]
    })
end

CSV.foreach("db/seed_data/technology.csv", :headers => true, :col_sep => ',', :encoding => 'windows-1251:utf-8') do |row|
  technology = Topic.find_by(name: 'Technology')
  Feed.create({
    :topic_id => technology.id,
    :name => row[0],
    :url => row[1]
    })
end

CSV.foreach("db/seed_data/finance.csv", :headers => true, :col_sep => ',', :encoding => 'windows-1251:utf-8') do |row|
  finance = Topic.find_by(name: 'Finance')
  Feed.create({
    :topic_id => finance.id,
    :name => row[0],
    :url => row[1]
    })
end

CSV.foreach("db/seed_data/sports.csv", :headers => true, :col_sep => ',', :encoding => 'windows-1251:utf-8') do |row|
  sports = Topic.find_by(name: 'Sports')
  Feed.create({
    :topic_id => sports.id,
    :name => row[0],
    :url => row[1]
    })
end
