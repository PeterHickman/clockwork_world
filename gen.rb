Node = Struct.new(:x, :z, :r, :s, :o, :m)

def gen_node(scale, obj, mtl)
	Node.new((rand() * 100).to_i - 50, (rand() * 100).to_i - 50, (rand() * 180).to_i, scale, obj, mtl)
end

def dist_ok(a, b)
	d = Math.sqrt(((a.x - b.x)**2).abs + ((a.z - b.z)**2).abs)
	d >= 9
end

def tweak(x)
	##
	# The trees are placed on an integer coordinate system
	# so to stop the trees 'lining up' their position is
	# tweaked a little to make it less obvious
	##
	x + (rand() - 0.5)
end

nodes = []

MAX_TREES = 50
MAX_STUMPS = 5

count = 0

loop do
	new_node = gen_node(0.5, '#tree-obj', '#tree-mtl')

	ok = true
	nodes.each do |old_node|
		ok = false unless dist_ok(new_node, old_node)
	end
	if ok
		nodes << new_node
		count += 1
	end

	break if count == MAX_TREES
end

count = 0

loop do
	new_node = gen_node(0.1, '#stump-obj', '#stump-mtl')

	ok = true
	nodes.each do |old_node|
		ok = false unless dist_ok(new_node, old_node)
	end
	if ok
		nodes << new_node
		count += 1
	end

	break if count == MAX_STUMPS
end

f = File.open('assets/trees.js', 'w')

f.puts "var trees = ["
nodes.each do |n|
	n.x = tweak(n.x)
	n.z = tweak(n.z)
	f.puts "\t{rotation: '0 #{n.r} 0', position: '#{n.x} 0 #{n.z}', scale: '#{n.s} #{n.s} #{n.s}', 'obj-model': 'obj: #{n.o}; mtl: #{n.m};', shadow: 'cast: true'},"
end
f.puts '];'
