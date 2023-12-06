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
    async function createdUser(prisma, data) {
      return prisma.user.create({
      data,
      });
    }
    const userCreationPromises = userData.map((data) => createdUser(prisma, data));
    const insertedUsers = await Promise.all(userCreationPromises);
    console.log('Users created:', numRecords);

  } catch (error) {
    console.error(`Error inserting users: ${error.message}`);
  } finally {
    await prisma.$disconnect();
  }
}

// Insert random users
insertRandomUserData(10000);