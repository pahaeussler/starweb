class PlanetsController < ApplicationController
  before_action :set_planet, only: [:show, :edit, :update, :destroy]

  # GET /planets
  # GET /planets.json
  def index
    @planets = get_all()
  end

  # GET /planets/1
  # GET /planets/1.json
  def show
    @planet= get_one(params[:id])
  end

  # GET /planets/new
  def new
    @planet = Planet.new
  end

  # GET /planets/1/edit
  def edit
  end

  # POST /planets
  # POST /planets.json
  def create
    @planet = Planet.new(planet_params)

    respond_to do |format|
      if @planet.save
        format.html { redirect_to @planet, notice: 'Planet was successfully created.' }
        format.json { render :show, status: :created, location: @planet }
      else
        format.html { render :new }
        format.json { render json: @planet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /planets/1
  # PATCH/PUT /planets/1.json
  def update
    respond_to do |format|
      if @planet.update(planet_params)
        format.html { redirect_to @planet, notice: 'Planet was successfully updated.' }
        format.json { render :show, status: :ok, location: @planet }
      else
        format.html { render :edit }
        format.json { render json: @planet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /planets/1
  # DELETE /planets/1.json
  def destroy
    @planet.destroy
    respond_to do |format|
      format.html { redirect_to planets_url, notice: 'Planet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_planet
      # @planet = Planet.find(params[:id])
      # @planet = execute_request("planets/#{params[:id]}")
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def planet_params
      params.fetch(:planet, {})
    end

  def get_all()
    puts "get all planets"
    query = 
    "{
      allPlanets {
        edges {
          node {
            ...planetFragment
          }
        }
      }
    }
    
    fragment planetFragment on Planet {
      id
      name
      # diameter
      # rotationPeriod
      # orbitalPeriod
      # gravity
      # population
      # climates
      # terrains
      # surfaceWater
    }
    
    "

      

    code, body = execute_request(query)
    puts "body[:data] #{body['data']['allPlanets']['edges']}, #{body.class.name}"
    return body['data']['allPlanets']['edges']
  end

  def get_one(id)
    puts "get one person id #{id}"
    id = '"'+id+'"'
    query = 
      "{
        planet(id: #{id}) {
          ...planetFragment
        }
      }
      
      fragment planetFragment on Planet {
        id
        name
        diameter
        rotationPeriod
        orbitalPeriod
        gravity
        population
        climates
        terrains
        surfaceWater
        filmConnection { edges { node { ...filmFragment }}}
        residentConnection {edges {node { ...residentFragment}}}
      }
      fragment filmFragment on Film {
        id
        title
      }
      
      fragment residentFragment on Person {
        id
        name
      }            
      "
    code, body = execute_request(query)
    puts "body[:data] #{body['data']['planet']}, #{body.class.name}"
    return body['data']["planet"]
  end

end
