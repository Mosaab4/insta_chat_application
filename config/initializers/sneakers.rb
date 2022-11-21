Sneakers.configure({ :amqp => 'amqp://guest:guest@rabbitmq:5672', :exchange => 'applications' })
Sneakers.logger.level = Logger::INFO