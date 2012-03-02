class FacebookFanPage < ActiveRecord::Base

  def self.create_pages
    pages = {
      '164045046982569' => {
        "name" => "GALERIE H+",
        "picture" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/157981_164045046982569_1691590353_s.jpg",
        "link" => "https://www.facebook.com/Galerie.H.plus"
      },
      '309346338172' => {
        "name" => "Consonaute",
        "picture" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/41572_309346338172_9719_s.jpg",
        "link" => "https://www.facebook.com/Consonaute"
      },
      '328839973377' => {
        "name" => "Socializ.fr",
        "picture" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash2/174877_328839973377_1040355013_s.jpg",
        "link" => "https://www.facebook.com/Socializ.fr"
      },
      '254911974569798' => {
        "name" => "Geekech",
        "picture" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/373050_254911974569798_920336215_s.jpg",
        "link" => "https://www.facebook.com/geekech"
      },
      '171850752835258' => {
        "name" => "Wordissimo",
        "picture" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/276447_171850752835258_2040340768_s.jpg",
        "link" => "https://www.facebook.com/wordissimo"
      },
      '135053329854920' => {
        "name" => "Diabete.ma",
        "picture" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/188161_135053329854920_1308644_s.jpg",
        "link" => "https://www.facebook.com/pages/Diabetema/135053329854920"
      },
      '111726672224482' => {
        "name" => "Neoweb Mag",
        "picture" => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/71037_111726672224482_6125079_s.jpg",
        "link" => "https://www.facebook.com/neowebmag"
      }
    }
    pages.each do |key, value|
      FacebookFanPage.find_or_create_by_page_id(:page_id => key)
    end
  end
end
