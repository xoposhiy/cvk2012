using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication2
{
	class Voter
	{
		public string Id;
		public string Phone;
		public bool MmmByRef;
		public bool MmmByPhone;
		public DateTime RegDate;
		public Voter(string line, HashSet<string> mmmPhones)
		{
			var parts = line.Split(';');
			Id = parts[0];
			Phone = parts[1];
			RegDate = DateTime.Parse(parts[2]);
			MmmByRef = parts[3] == "1";
			MmmByPhone = mmmPhones.Contains(Phone);
		}

		public bool IsMMM
		{
			get { return MmmByRef || MmmByPhone; }
		}
	}

	class Candidate
	{
		public Candidate(string line)
		{
			var parts = line.Split(';');
			Id = int.Parse(parts[0]);
			Name = parts[1];
			List = int.Parse(parts[2]);
		}

		public int Id;
		public string Name;
		public int List;
	}

	class Program
	{
		private const int Artemov = 16; // Он добавился в список Мавроди позже.
		private static readonly DateTime MMM_LK_Blocked = new DateTime(2012, 10, 16, 15, 0, 0); // В это время Мавро заблокировал кабинеты МММщикам
		private static HashSet<int> mmmCandidates;

		static void Main(string[] args)
		{
			LoadCandidates();
			var users = LoadUsers();
			var votes = LoadVotes();
			Console.WriteLine("1 vote in common list: " + votes.Count(SingleVoteInCommon));
			CreateBanLists(votes, users);

			WriteVotingStats(votes);
			WriteGroupStatistics(votes);
		}

		private static void WriteGroupStatistics(List<IGrouping<string, int>> votes)
		{
			var votesWithMoreThan4ChecksInCommonList = votes.Where(v => v.Where(c => allCandidates[c].List == 1).Distinct().Count() > 4);
			var votings = votesWithMoreThan4ChecksInCommonList.Select(
				v => string.Join(",", 
					v.Where(c => allCandidates[c].List == 1)
					.Distinct().OrderBy(c => c)
					.Select(c => c.ToString())
					.ToArray()
				)).ToList();
			var groups = votings.GroupBy(v => v);
			var groupSizes = groups.Select(g => new {Votings = g.Key, Size = g.Count()}).OrderByDescending(g => g.Size);
			File.WriteAllLines("groups_sizes.txt", groupSizes.Select(gs => gs.Size+" " + gs.Votings));
		}

		private static void LoadCandidates()
		{
			allCandidates = File.ReadAllLines("options.csv").Skip(1).Select(line => new Candidate(line)).ToDictionary(c => c.Id, c => c);
			mmmCandidates = new HashSet<int>(File.ReadAllLines("mmm_candidates.csv").Select(line => int.Parse(line.Split(';')[0])));
		}

		private static void CreateBanLists(List<IGrouping<string, int>> votes, Dictionary<string, Voter> users)
		{
			Console.WriteLine("Creating banlists...");
			var banAll = votes.Where(VoteLikeMavrodi).Select(g => g.Key).ToList();
			File.WriteAllLines("ban_all.txt", banAll);
			Console.WriteLine("	Ban all: {0}", banAll.Count);
			var banRegAfterBlock = banAll.Where(person => users[person].RegDate > MMM_LK_Blocked).ToList();
			File.WriteAllLines("ban_reg_after_block.txt", banRegAfterBlock);
			Console.WriteLine("	Ban reg after LK block: {0}", banRegAfterBlock.Count);
			var banDetectedAndRegAfterBlock = banRegAfterBlock.Where(person => users[person].MmmByPhone || users[person].MmmByRef).ToList();
			File.WriteAllLines("ban_detected.txt", banDetectedAndRegAfterBlock);
			Console.WriteLine("	Ban detected before voting: {0}", banDetectedAndRegAfterBlock.Count);
		}

		private static List<IGrouping<string, int>> LoadVotes()
		{
			Console.WriteLine("Reading votes...");
			var votes = File.ReadAllLines("votes.csv").OrderBy(v => v).GroupBy(v => v.Substring(0, 36), v => int.Parse(v.Substring(37))).ToList();
			Console.WriteLine("	Voters: {0}", votes.Count);
			var anyVoter = votes.First();
			Console.WriteLine("	Vote sample: " + anyVoter.Key + " " + string.Join(", ", anyVoter.ToArray()));
			return votes;
		}

		private static Dictionary<string, Voter> LoadUsers()
		{
			Console.WriteLine("Reading users...");
			var mmmPhones = new HashSet<string>(File.ReadAllLines("mmm_phones.csv").Distinct());
			var users = File.ReadAllLines("voters.csv").Skip(1).Select(line => new Voter(line, mmmPhones)).ToDictionary(u => u.Id, u => u);
			Console.WriteLine("	Users: {0} (MMM: {1})", users.Count, users.Count(u => u.Value.IsMMM));
			File.WriteAllLines("detected-mmm.txt", users.Where(u => u.Value.IsMMM).Select(kv => kv.Key));
			return users;
		}

		private static Dictionary<int, Candidate> allCandidates;

		private static void WriteVotingStats(List<IGrouping<string, int>> votes)
		{
			File.WriteAllLines("voting_like_mmm_in_common_list.txt", votes.Select(VotesCountLikeMavrodiInCommonList).OrderByDescending(m => m).Select(m => m.ToString()));
		}

		private static bool VoteLikeMavrodi(IEnumerable<int> votes)
		{
			var v = votes.Distinct().ToList();
			var mmmScore = v.Count(mmmCandidates.Contains);
			if (mmmScore == 37 && !v.Contains(Artemov)) return true;
			if (mmmScore == 38) return true;
			return false;
		}

		private static int VotesCountLikeMavrodiInCommonList(IEnumerable<int> votes)
		{
			return votes.Distinct().Count(v => mmmCandidates.Contains(v) && allCandidates[v].List == 1);
		}

		private static bool SingleVoteInCommon(IEnumerable<int> votes)
		{
			foreach(var v in votes.Where(v => !allCandidates.ContainsKey(v)))
				Console.WriteLine(v);
			return votes.Distinct().Count(v => allCandidates[v].List == 1) == 1;
		}
	}
}
