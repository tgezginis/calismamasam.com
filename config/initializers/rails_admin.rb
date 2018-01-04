module RailsAdmin
  module Extensions
    module CanCanCan2
      class AuthorizationAdapter < RailsAdmin::Extensions::CanCanCan::AuthorizationAdapter
        def authorize(action, abstract_model = nil, model_object = nil)
          return unless action
          reaction, subject = fetch_action_and_subject(action, abstract_model, model_object)
          @controller.current_ability.authorize!(reaction, subject)
        end

        def authorized?(action, abstract_model = nil, model_object = nil)
          return unless action
          reaction, subject = fetch_action_and_subject(action, abstract_model, model_object)
          @controller.current_ability.can?(reaction, subject)
        end

        def fetch_action_and_subject(action, abstract_model, model_object)
          reaction = action
          subject = model_object || abstract_model&.model
          unless subject
            subject = reaction
            reaction = :read
          end
          return reaction, subject
        end
      end
    end
  end
end

RailsAdmin.add_extension(:cancancan2, RailsAdmin::Extensions::CanCanCan2, authorization: true)


RailsAdmin.config do |config|
  include RailsAdminTagList::SuggestionsHelper
  config.main_app_name = ["Çalışma Masam - Yönetim Paneli"]

  config.authenticate_with do
    warden.authenticate! scope: :user
    redirect_to main_app.root_path unless current_user
    redirect_to main_app.root_path if current_user.role == 'user'
  end
  config.authorize_with :cancancan2

  config.current_user_method(&:current_user)

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
    history_index
    history_show
  end

  hidden_models = ['Mailkick::OptOut', 'GalleryImage', 'Like', 'PostImage', 'ProductImage']
  hidden_models.each do |model|
    config.model model do
      visible false
    end
  end

  config.model 'Category' do
    list do
      field :id
      field :title
    end
    edit do
      field :title
    end
  end

  config.model 'Gallery' do
    configure :image do
      formatted_value do
        bindings[:view].tag(:img, { :src => bindings[:object].decorate.first_image_url(:thumb), width: '40' })
      end
    end

    list do
      field :id
      field :is_active
      field :image
      field :title
      field :categories
      field :user do
        formatted_value do
          value.name.to_s
        end
      end
      field :created_at
    end
    edit do
      field :is_active
      field :title
      field :job_title
      field :categories
      field :gallery_images do
        orderable true
        label "Görseller"
      end
      field :user do
        default_value do
          bindings[:view]._current_user.id
        end
      end
    end
    show do
      field :id
      field :is_active
      field :title
      field :job_title
      field :categories
      field :gallery_images do
        # It is needed to show nested form
        active true
      end
    end
  end

  config.model 'Post' do
    list do
      field :id
      field :image do
        pretty_value do
          bindings[:view].tag(:img, { :src => bindings[:object].image(:thumb), width: '50' })
        end
      end
      field :is_active
      field :title
      field :published_at
    end
    edit do
      field :is_active
      field :image
      field :post_images do
        orderable true
      end
      field :title
      field :job_title
      field :company
      field :twitter_url
      field :categories
      field :description
      field :body do
        html_attributes rows: 10, cols: 120
      end
      field :products do
        html_attributes do
          { style: 'width: 100%;' }
        end
        label "Ekipmanlar"
      end
      field :video_url
      field :published_at do
        date_format :default
      end
    end
  end

  config.model 'User' do
    list do
      field :id
      field :name
      field :email
      field :last_sign_in_at
      field :role, :enum do
        enum do
          User.roles
        end
      end
    end
    edit do
      field :name
      field :email
      field :password
      field :password_confirmation
      field :role
    end
    show do
      field :name
      field :email
      field :role
      field :sign_in_count
      field :last_sign_in_at
      field :last_sign_in_ip
    end
  end

  config.model 'Product' do
    configure :show_image do
      formatted_value do
        bindings[:view].tag(:img, { :src => bindings[:object].image(:thumb), width: '40' })
      end
      label "Görsel"
    end

    list do
      field :id
      field :show_image
      field :brand
      field :name
      field :created_at
    end
    edit do
      field :name
      field :url
      field :brand
      field :image
      field :category_id, :enum do
        enum do
          ProductCategory.bottom_categories.order(:path_cache).map { |c| [ c.path_cache, c.id] }
        end
        label "Kategori"
      end
    end
    show do
      field :id
      field :image
      field :name
      field :brand
      field :category
    end
  end

  config.model 'ProductCategory' do
    list do
      field :id
      field :title
      field :created_at
    end
    edit do
      field :ancestry, :enum do
        enum do
          root = [['Ana kategori', nil]]
          except = bindings[:object].id.nil? ? 0 : bindings[:object].id
          categories = ProductCategory.where("id != ?", except)
          categories = categories.where("ancestry_depth <= ?", bindings[:object].ancestry_depth) unless bindings[:object].id.nil?
          root.concat(categories.order(:path_cache).map { |c| [ ("&nbsp;&nbsp;&nbsp;" * c.depth + c.title).html_safe, c.id] })
        end
      end
      field :title
      field :products
    end
  end
end
