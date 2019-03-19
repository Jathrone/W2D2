class Employee
    attr_reader :salary

    def initialize(name, title, salary, boss)
        @name = name
        @title = title
        @salary = salary
        @boss = boss
    end

    def bonus(multiplier, *arg) 
        self.salary * multiplier
    end
end


class Manager < Employee
    attr_reader :employees
    def initialize(name, title, salary, boss, *employees)
        super(name, title, salary, boss)
        add_employees(*employees)
    end

    def add_employees(*employees)
        @employees ||= []
        employees.each {|emp| @employees << emp}
    end

    def bonus(multiplier, toplevel = true)
        if toplevel
            sum = 0
        else
            sum = self.salary * multiplier
        end
        self.employees.each do |emp|
            sum += emp.bonus(multiplier, false)
        end
        sum 
    end
end

if __FILE__ == $PROGRAM_NAME
    shawna = Employee.new("Shawna", 'TA', 12000, "darren")
    david = Employee.new("David", 'TA', 10000, "darren")
    darren = Manager.new("Darren", 'TA Manager', 78000, "ned", shawna, david)
    ned = Manager.new('Ned', 'founder', 1000000, nil, darren)
    
    p ned.bonus(5)
    p darren.bonus(4)
    p david.bonus(3)
end