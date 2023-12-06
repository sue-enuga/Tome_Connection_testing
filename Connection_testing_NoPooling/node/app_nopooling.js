const { PrismaClient } = require('@prisma/client');
const faker = require('faker'); // Library for generating fake data

const prisma = new PrismaClient();

async function insertRandomUserData(numRecords) {
  const userData = [];

  for (let i = 0; i < numRecords; i++) {
    const user = {
      name: faker.name.findName(), // Generate a random name
      email: faker.internet.email(),
      // Add more fields as needed with faker.js or other random data generation methods
    };
    userData.push(user);
  }

  try {
    const createdUsers = await prisma.user.createMany({
      data: userData,
    });
    console.log(`Inserted ${createdUsers.count} users.`);
  } catch (error) {
    console.error(`Error inserting users: ${error.message}`);
  } finally {
    await prisma.$disconnect();
  }
}

// Insert 10 random users
insertRandomUserData(1);