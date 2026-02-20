class AmountsController < ApplicationController
  before_action :set_amount, only: %i[ show edit update ] # destroy ]

  # GET /amounts or /amounts.json
  def index
    @amounts = Amount.all
  end

  # GET /amounts/1 or /amounts/1.json
  def show
  end

  # GET /amounts/new
  def new
    @amount = Amount.new
  end

  # GET /amounts/1/edit
  def edit
  end

  # POST /amounts or /amounts.json
  def create
    @amount = Amount.new(amount_params)

    respond_to do |format|
      if @amount.save
        format.html { redirect_to @amount, notice: "Amount was successfully created." }
        format.json { render :show, status: :created, location: @amount }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @amount.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /amounts/1 or /amounts/1.json
  def update
    respond_to do |format|
      if @amount.update(amount_params)
        format.html { redirect_to @amount, notice: "Amount was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @amount }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @amount.errors, status: :unprocessable_entity }
      end
    end
  end

  # # DELETE /amounts/1 or /amounts/1.json
  # def destroy
  #   @amount.destroy!
  #
  #   respond_to do |format|
  #     format.html { redirect_to amounts_path, notice: "Amount was successfully destroyed.", status: :see_other }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_amount
      @amount = Amount.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def amount_params
      params.expect(amount: [ :ingredient_id, :serving, :serving_variant, :volume, :volume_unit_id, :volume_variant,
                              :weight, :weight_unit_id, ]).tap do |params|
        if params.has_key?(:volume_unit_id) && params[:volume].blank?
          params.delete(:volume_unit_id)
        end
        if params.has_key?(:weight_unit_id) && params[:weight].blank?
          params.delete(:weight_unit_id)
        end

        [ :serving, :volume, :weight ].each do |key|
          params[key] = expand_fractional(params[key]) if params.has_key?(key) && params[key].is_a?(String)
        end
      end
    end

  def expand_fractional(number_string)
    number = BigDecimal(number_string)
    number_string.sub!(number.to_i.to_s, "0")

    replacements = [
      { expanded: "0.333", from: [ "0.33", "0.34" ] }, # 1/3
      { expanded: "0.667", from: [ "0.66", "0.67" ] }, # 2/3
      { expanded: "0.167", from: [ "0.16", "0.17" ] }, # 1/6
      { expanded: "0.833", from: [ "0.83", "0.84" ] }, # 5/6
    ]

    expanded = replacements.find { |replacement| replacement[:from].include?(number_string) }&.fetch(:expanded)
    expanded.nil? ? number_string : expanded.sub("0", number.to_i.to_s)
  end
end
