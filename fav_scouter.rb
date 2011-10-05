# -*- coding: utf-8 -*-
=begin rdoc
ふぁぼスカウター
=end

Plugin.create(:fav_scouter) do

  filter_command do |menu|
    menu[:fav_scouter] = {
      :slug => :fav_scouter,
      :name => 'ふぁぼスカウター',
      :condition => lambda{ |m| m.message.user },
      :exec => lambda{ |m|
        Thread.new {
          user = m.message.user
          fav_count = user[:favourites_count]
          a = [(fav_count / 40 + ((fav_count % 40) == 0 ? 0 : 1)), 80].min
          b = [fav_count / 200, 16].min
          favorited = Post.primary_service.scan(:favorites, :id => user.id, :count => 20, :page => a)
          c = (Time.now - favorited.last[:created]).to_i
          Plugin.call(:update, nil, [Message.new(:message => "@#{user.idname}のふぁぼ力 #{31.25 * fav_count * 8302.5 * b / c}",
                                                 :system => true)])
        }
      },
      :visible => true,
      :role => :message }
    [menu]
  end

end
