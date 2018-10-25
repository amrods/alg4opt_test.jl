let
    M = 40
    k_max = 50
    f = x -> norm(x)
    seed!(0)
    @test sum(genetic_algorithm(f, rand_population_binary(M, 5), k_max, TruncationSelection(5), SinglePointCrossover(), BitwiseMutation(0.1))) ≤ 1
    seed!(0)
    @test sum(genetic_algorithm(f, rand_population_binary(M, 5), k_max, TournamentSelection(5), TwoPointCrossover(), BitwiseMutation(0.1))) ≤ 1
    seed!(0)
    @test sum(genetic_algorithm(f, rand_population_binary(M, 5), k_max, RouletteWheelSelection(), UniformCrossover(), BitwiseMutation(0.1))) ≤ 1
    seed!(0)
    @test f(genetic_algorithm(f, rand_population_uniform(M, [-2.0, -2.0], [2.0,2.0]), k_max, TruncationSelection(5), SinglePointCrossover(), GaussianMutation(0.01))) ≤ 0.1
    seed!(0)
    @test f(genetic_algorithm(f, rand_population_normal(M, [0.0, 0.0], [1.0,1.0]), k_max, TournamentSelection(5), TwoPointCrossover(),    GaussianMutation(0.1))) ≤ 0.1
    seed!(0)
    @test f(genetic_algorithm(f, rand_population_cauchy(M, [0.0, 0.0], [1.0,1.0]), k_max, RouletteWheelSelection(), UniformCrossover(),   GaussianMutation(0.1))) ≤ 0.1
    seed!(0)
    @test f(genetic_algorithm(f, rand_population_normal(M, [0.0, 0.0], [1.0,1.0]), k_max, RouletteWheelSelection(), InterpolationCrossover(0.5),   GaussianMutation(0.1))) ≤ 0.1

    seed!(0)
    population = [rand(Uniform(-10.0, 10.0), 2) for i in 1 : 100]
    @test rosenbrock(firefly(rosenbrock, population, 50)) < 0.01

    seed!(0)
    population = [rand(Uniform(-10.0, 10.0), 2) for i in 1 : 100]
    @test rosenbrock(differential_evolution(rosenbrock, population, 50)) < 0.01

    seed!(0)
    function spawn_particle()
        x = rand(Uniform(-10.0, 10.0), 2)
        v = rand(Uniform( -5.0,  5.0), 2)
        return Particle(x, v, x)
    end
    particles = [spawn_particle() for i in 1 : 100]
    particles = particle_swarm_optimization(rosenbrock, particles, 50)
    @test minimum(rosenbrock(P.x_best) for P in particles) < 0.01

    seed!(0)
    function spawn_nest()
        x = rand(Uniform(-10.0, 10.0), 2)
        y = rosenbrock(x)
        return Nest(x,y)
    end
    nests = [spawn_nest() for i in 1 : 100]
    nests = cuckoo_search(rosenbrock, nests, 50)
end