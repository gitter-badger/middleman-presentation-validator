class ValidationJobsController < ApplicationController
  before_action :set_validation_job, only: [:show, :edit, :update, :destroy, :restart]

  # GET /validation_jobs
  # GET /validation_jobs.json
  def index
    @validation_jobs = ValidationJobDecorator.decorate_collection(ValidationJob.order(start_time: :desc))
  end

  # GET /validation_jobs/1
  # GET /validation_jobs/1.json
  def show
    respond_to do |format|
      format.html
      format.json
      format.bson
    end
  end

  # GET /validation_jobs/new
  def new
    @validation_job = ValidationJob.new
  end

  # GET /validation_jobs/1/edit
  def edit
  end

  def restart
    @validation_job.restart!

    respond_to do |format|
      format.html { redirect_to @validation_job, notice: 'ValidationJob was successfully created.' }
    end
  end

  # POST /validation_jobs
  # POST /validation_jobs.json
  def create
    checksum = Digest::SHA256.hexdigest params['validation_job']['source_file'].read
    existing_job?(checksum) && return

    @validation_job = ValidationJob.new(validation_job_params)

    @validation_job.class.aasm.states.dup.delete_if { |s| %w(created completed failed) }.each do |s|
      @validation_job.progress[s.name] = nil
    end

    unless params['validation_job']['source_file'] == '{}'
      @validation_job.source_file = params['validation_job']['source_file'].tempfile
    end

    @validation_job.callback_url = params['validation_job']['callback_url']
    @validation_job.working_directory = Dir.mktmpdir('presentation')
    @validation_job.checksum = checksum
    @validation_job.prepare_environment!

    respond_to do |format|
      if @validation_job.save
        format.html { redirect_to @validation_job, notice: 'ValidationJob was successfully created.' }
        format.json { render :show, status: :created, location: @validation_job }
      else
        format.html { render :new }
        format.json { render json: @validation_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /validation_jobs/1
  def update
    @validation_job.update(validation_job_params)

    respond_to do |format|
      if @validation_job.restart!
        format.html { redirect_to @validation_job, notice: 'ValidationJob was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /validation_jobs/1
  # DELETE /validation_jobs/1.json
  def destroy
    @validation_job.destroy
    respond_to do |format|
      format.html { redirect_to validation_jobs_url, notice: 'ValidationJob was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # DELETE /validation_jobs
  def destroy_all
    ValidationJob.destroy_all

    respond_to do |format|
      format.html { redirect_to validation_jobs_url, notice: 'ValidationJob was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_validation_job
      @validation_job = ValidationJob.find(params[:id]).decorate
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def validation_job_params
      params.require(:validation_job).permit(:source_file, :callback_url)
    end

    def find_job(checksum)
      ValidationJob.where(checksum: checksum).first
    end

    def existing_job?(checksum)
      validation_job = find_job(checksum)

      unless validation_job.blank?
        redirect_to validation_job
        return true
      end

      false
    end

end

