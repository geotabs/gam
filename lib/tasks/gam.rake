namespace :gam do
  # This collects the results from an action and returns them as an array
  def collect_task_results(task, *args)
    task = Rake::Task[task] unless task.is_a? Rake::Task
    task.actions.map do |action|
      action.call(
        self,
        Rake::TaskArguments.new(task.arg_names, args)
      )
    end
  end

  desc "PUP is responsible for initiating a transfer from one peer to another."
  namespace :pup do
    desc "This invokes the entire PUP process."
    task :invoke, [:destination] => :environment do |task, args|
      # Step 1: Collect all tabs
      # Step 2: Use GTH to package the data
      # Step 3: Send to destination

      # Stubs to hold some testing data
      Datum = Struct.new(:id, :title, :body, :parent_id, :created_on)
      data = [
        Datum.new(1, "one", "lorem", nil, Time.now - 1.days),
        Datum.new(2, "two", "ipsum", 1, Time.now - 12.hours)
      ]

      payload = data.map do |datum|
        collect_task_results 'gam:gth',
          datum.id,
          [],
          datum.created_on,
          datum.parent_id,
          {title: datum.title, body: datum.body}
      end

      collect_task_results 'gam:pup:send', args[:destination], payload
    end

    desc "This sends all filtered tabs to the destination."
    task :send, [:destination, :data] do |task, args|
      puts args[:destination]
      puts args[:data]
    end
  end

  desc "GTH is responsible for securing outgoing application data for the stack."
  task :gth, [:id, :contacts, :published_on, :parent_id, :data] => :environment do |task, args|
    # Step 1: Validate input (model)
    # Step 2: Assemble data structure (model)
    # Step 3: Package structure with hash (model)
    # TODO: Setup a model with validations, validate and send it off to the next op.
    args
  end
end
