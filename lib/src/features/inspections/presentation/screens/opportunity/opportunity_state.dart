import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';

sealed class OpportunityState {}

class LoadingOpportunityState extends OpportunityState {}

class FilledOpportunityState extends OpportunityState {
  final Opportunity opportunity;

  FilledOpportunityState({ required this.opportunity });
}

class SavingOpportunityState extends OpportunityState {}

class DeletingOpportunityState extends OpportunityState {}

class ErrorOpportunityState extends OpportunityState {
  final String message;

  ErrorOpportunityState({ required this.message });
}