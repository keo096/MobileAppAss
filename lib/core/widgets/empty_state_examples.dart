// This file contains usage examples for EmptyState widget
// You can delete this file after reviewing the examples

/*
USAGE EXAMPLES:

1. Basic Empty State (No Data):
   EmptyState(
     type: EmptyStateType.empty,
   )

2. No History:
   EmptyState(
     type: EmptyStateType.noHistory,
     actionText: 'Start a Quiz',
     onAction: () {
       // Navigate to quiz selection
     },
   )

3. Network Error:
   EmptyState(
     type: EmptyStateType.networkError,
     actionText: 'Retry',
     onAction: () {
       // Retry loading data
     },
   )

4. Server Error:
   EmptyState(
     type: EmptyStateType.serverError,
     actionText: 'Try Again',
     onAction: () {
       // Retry API call
     },
   )

5. Custom Empty State:
   EmptyState(
     type: EmptyStateType.empty,
     title: 'No Quizzes Available',
     message: 'Check back later for new quizzes',
     icon: Icons.quiz_outlined,
     iconColor: AppColors.primaryPurple,
     actionText: 'Refresh',
     onAction: () {
       // Refresh data
     },
   )

6. Custom Icon Widget:
   EmptyState(
     type: EmptyStateType.error,
     customIcon: Image.asset(
       AppAssets.errorIllustration,
       width: 120,
       height: 120,
     ),
     title: 'Oops!',
     message: 'Something went wrong',
     actionText: 'Go Back',
     onAction: () => Navigator.pop(context),
   )

7. No Action Button:
   EmptyState(
     type: EmptyStateType.notFound,
     // No actionText/onAction = no button shown
   )

8. In a ListView/ScrollView:
   if (items.isEmpty)
     EmptyState(
       type: EmptyStateType.empty,
       actionText: 'Add Item',
       onAction: () {
         // Add new item
       },
     )
   else
     ListView.builder(...)

9. In a FutureBuilder:
   FutureBuilder<List<Item>>(
     future: fetchItems(),
     builder: (context, snapshot) {
       if (snapshot.hasError) {
         return EmptyState(
           type: EmptyStateType.error,
           actionText: 'Retry',
           onAction: () {
             // Retry fetch
           },
         );
       }
       if (snapshot.hasData && snapshot.data!.isEmpty) {
         return EmptyState(
           type: EmptyStateType.empty,
         );
       }
       if (snapshot.hasData) {
         return ListView.builder(...);
       }
       return LoadingWidget(...);
     },
   )
*/

