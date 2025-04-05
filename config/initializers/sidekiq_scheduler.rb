if Sidekiq.server?
  Sidekiq.configure_server do |config|
    config.on(:startup) do
      schedule_file = Rails.root.join('config/sidekiq.yml')

      if File.exist?(schedule_file)
        Sidekiq.schedule = YAML.load_file(schedule_file)[:scheduler]
        Sidekiq::Scheduler.reload_schedule!
      end
    end
  end
end