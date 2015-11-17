using System;
using RobotCleaner;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace RobotCleanerTest
{
    [TestClass]
    public class RobotCleanerTest
    {
        private static Robot robot;

        [ClassInitialize]
        public static void RobotTestInit(TestContext context)
        {
            robot = Robot.GetInstance();
        }

        [TestMethod]
        public void TestUniqueRobot()
        {
            Robot robotB = Robot.GetInstance();
            Assert.IsTrue(robot == robotB);
        }

        [TestMethod]
        public void TestInvalidCommandsRange()
        {
            var setup = robot.Setup(10001, 100000, 100000);
            Assert.IsFalse(setup.Item1);
        }

        [TestMethod]
        public void TestValidArea()
        {
            var setup = robot.Setup(10000, 100000, 100000);
            Assert.IsTrue(setup.Item1);
        }

        [TestMethod]
        public void TestInValidArea()
        {
            var setup = robot.Setup(10000, 100000, 100001);
            Assert.IsFalse(setup.Item1);
        }

        [TestMethod]
        public void TestInvalidDirection()
        {
            var step = robot.ExecStep('L', 1);
            Assert.IsFalse(step.Item1);
        }

        [TestMethod]
        public void TestInvalidStepsNumber()
        {
            var step = robot.ExecStep('N', 100001);
            Assert.IsFalse(step.Item1);
        }

        [TestMethod]
        public void TestValidClean()
        {
            var setup = robot.Setup(1, -100000, 1);
            if (!setup.Item1)
            {
                Assert.IsTrue(setup.Item1);
                return;
            }

            var step = robot.ExecStep('N', 1);
            Assert.IsTrue(step.Item1);
        }

        [TestMethod]
        public void TestVertex()
        {
            var setup = robot.Setup(1, 100000, 100000);
            if (!setup.Item1)
            {
                Assert.IsTrue(setup.Item1);
                return;
            }

            Assert.IsTrue(setup.Item2 == "Setup OK, Origin at Vertex! Perform Clean please");
        }
    }
}
