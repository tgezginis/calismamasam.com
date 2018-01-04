namespace :posts do
  desc 'Notify Awating Posts'
  task notify_awaiting_posts: :environment do
    PostInteractors::NotifyAwaitingPosts.call
  end
end
