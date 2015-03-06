using System;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CannonAttack;

namespace CannonAttackTest
{
    [TestClass]
    public class CannonAttackTest
    {
        private static Cannon cannon;

        [ClassInitialize]
        public static void CannonTestsInitialize(TestContext testContext)
        {
            cannon = Cannon.GetInstance();
        }

        [TestInitialize]
        public void ResetCannonObject()
        {
            cannon.Reset();
        }

        [TestMethod]
        public void TestCannonIdValid()
        {
            Assert.IsNotNull(cannon.Id);
        }

        [TestMethod]
        public void TestCannonMultipleInstances()
        {
            Cannon cannon2 = Cannon.GetInstance();
            Assert.IsTrue(cannon == cannon2);
        }

        [TestMethod]
        public void TestCannonShootIncorrectAngle()
        {
            var shot = cannon.Shoot(95, 100);
            Assert.IsFalse(shot.Item1);
        }

        [TestMethod]
        public void TestCannonShootVelocityGreaterThanSpeedOfLight()
        {
            var shot = cannon.Shoot(45, 300000001);
            Assert.IsFalse(shot.Item1);
        }

        [TestMethod]
        public void TestCannonShootMiss()
        {
            cannon.SetTarget(4000);
            var shot = cannon.Shoot(45, 350);
            Assert.IsTrue(shot.Item2 == "Missed cannonball landed at 12621 meters");
        }

        [TestMethod]
        public void TestCannonShootHit()
        {
            cannon.SetTarget(12621);
            var shot = cannon.Shoot(45, 350);
            Assert.IsTrue(shot.Item2 == "Hit - 1 Shot(s)");
        }

        [TestMethod]
        public void TestCannonCountShots()
        {
            cannon.SetTarget(12621);
            var shot = cannon.Shoot(45, 350);
            Assert.IsTrue(shot.Item2 == "Hit - 1 Shot(s)", "Number of shots:" + cannon.Shots);
        }
    }
}
