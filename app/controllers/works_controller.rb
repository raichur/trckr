class WorksController < ApplicationController
  before_filter :authenticate_user!
  def index
    if (params[:days])
      @works = Work.recentdays(params[:days]).order('datetimeperformed desc').paginate(:page => params[:page])
    else
      @works = Work.all.order('datetimeperformed desc').paginate(:page => params[:page])
    end
  end

  def show
    @work = Work.find(params[:id])
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(params[:work].permit(:project_id, :datetimeperformed, :hours, :description))
    @work.user = current_user
    if params[:doc]
      uploaded_io = params[:doc]
      File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
        @work.doc = uploaded_io.original_filename
      end
    end
    respond_to do |format|
      if @work.save
        format.html { redirect_to @work, notice: 'New work successfully created' }
        format.js { }
      else
        format.html { render 'new' }
        format.js { }
      end
    end
  end

  def edit
    @work = Work.find(params[:id])
  end


  def update
    @work = Work.find(params[:id])
    @work.user = current_user
    if @work.update(params[:work].permit(:project_id, :datetimeperformed, :hours, :description))
      flash[:notice] = 'Work successfully updated'
      redirect_to @work
    else
      render 'edit'
    end

  end

end
